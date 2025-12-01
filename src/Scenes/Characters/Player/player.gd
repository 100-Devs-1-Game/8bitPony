class_name Player
extends CharacterBody2D

enum PonyType { Earth, Pegasus, Unicorn, Max }
enum PonyStateMachine { Idle, Run, Jump, Fall, Action, Die }

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var bullet_anchor: Node2D = $BulletAnchor
@onready var attack_timer: Timer = $AttackTimer
@onready var hurt_timer: Timer = $HurtTimer
@onready var recovery_timer: Timer = $RecoveryTimer
@onready var blink_timer: Timer = $BlinkTimer

# Sounds
@onready var shoot_sound: AudioStreamPlayer = $Shoot
@onready var hit_sound: AudioStreamPlayer = $Hit
@onready var swap_sound: AudioStreamPlayer = $Swap

@export var health: int = 3:
	set(new_health):
		health = new_health
		health_changed.emit(health)
@export var score: int = 0:
	set(new_score):
		score = new_score
		score_changed.emit(score)
@export var magic_bullet: PackedScene
@export var speed: float = 600.0
@export var flying_strength: float = 2500.0
@export var max_vertical_velocity: float = 500.0
@export var jump_velocity: float = -550.0
@export var gravity_change: float = 200
@export var hurt_color: Color = Color.RED
@export var pony_type: PonyType = PonyType.Unicorn
@export var pony_sprite_by_type: Dictionary[PonyType, SpriteFrames]
@export var smoke: PackedScene

var pony_states: int = PonyStateMachine.Idle

signal health_changed(new_health: int)
signal score_changed(new_score: int)

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = gravity_change + ProjectSettings.get_setting("physics/2d/default_gravity")
var flying: bool = false


func _ready() -> void:
	set_pony_type(pony_type)


func _process(_delta: float) -> void:
	_update_pony_state()
	_sprite_handle()


func _physics_process(delta):
	_default_movement(delta) #handles the movement


func _default_movement(delta: float): #player moment from the character2d script
	if flying:
		velocity.y -= flying_strength * delta
	elif not is_on_floor():
		velocity.y += gravity * delta
	velocity.y = max(-max_vertical_velocity, min(max_vertical_velocity, velocity.y))
	
	if not has_state(PonyStateMachine.Die):
		var direction = Input.get_axis("Left", "Right")
		if direction:
			velocity.x = direction * speed
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
	
	move_and_slide()


func _unhandled_input(event: InputEvent) -> void:
	if not has_state(PonyStateMachine.Die):
		if event.is_action_pressed("Action"):
			add_state(PonyStateMachine.Action)
			match pony_type:
				PonyType.Pegasus:
					flying = true
				PonyType.Unicorn:
					var bullet =  magic_bullet.instantiate()
					if bullet is MagicBullet:
						bullet.global_position = bullet_anchor.global_position
						if sprite.flip_h:
							bullet.velocity = -bullet.velocity
					get_parent().add_child(bullet)
					shoot_sound.play()
					attack_timer.start()
				PonyType.Earth:
					attack_timer.start()
		elif event.is_action_released("Action"):
			match pony_type:
				PonyType.Pegasus:
					flying = false
					remove_state(PonyStateMachine.Action)
		elif event.is_action_pressed("Jump") and is_on_floor():
			velocity.y = jump_velocity
		elif event.is_action_pressed("ChangePony"):
			_change_pony()


func take_damage(damage: int = 1):
	if not has_state(PonyStateMachine.Die) and recovery_timer.is_stopped():
		health = max(0, health - damage)
		hit_sound.play()
		_flash_red()
		recovery_timer.start()
		blink_timer.start()
		visible = false
		if health <= 0:
			add_state(PonyStateMachine.Die)
			flying = false
			velocity.x = 0


func health_pickup(value: int = 1): #pick up extra life
	if not has_state(PonyStateMachine.Die):
		health += value


func _flash_red(): #player gets hit, flash red
	sprite.modulate = hurt_color
	hurt_timer.start()


func _update_pony_state() -> void:
	if has_state(PonyStateMachine.Die):
		return  # death overrides everything
	
	# --- In the air ---
	if not is_on_floor():
		if velocity.y < 0:
			add_state(PonyStateMachine.Jump)
			remove_state(PonyStateMachine.Fall)
		else:
			add_state(PonyStateMachine.Fall)
			remove_state(PonyStateMachine.Jump)
	else:
		remove_state(PonyStateMachine.Jump)
		remove_state(PonyStateMachine.Fall)
	
	# --- Action ---
	match pony_type:
		PonyType.Pegasus:
			pass
		_:
			if attack_timer.is_stopped():
				remove_state(PonyStateMachine.Action)
	
	if abs(velocity.x) > 0.1:
		add_state(PonyStateMachine.Run)
		remove_state(PonyStateMachine.Idle)
	else:
		add_state(PonyStateMachine.Idle)
		remove_state(PonyStateMachine.Run)


func _sprite_handle(): #handles sprite stuff
	if velocity.x < 0:
		sprite.flip_h = true
		bullet_anchor.position.x = min(-bullet_anchor.position.x, bullet_anchor.position.x)
	elif velocity.x > 0:
		sprite.flip_h = false
		bullet_anchor.position.x = max(-bullet_anchor.position.x, bullet_anchor.position.x)
		
	var anim_value: int = highest_set_bit_index_fast(pony_states)
	var anim_str: String = str(PonyStateMachine.keys()[anim_value])
	if sprite.sprite_frames.has_animation(anim_str):
		sprite.play(anim_str)


func set_pony_type(in_pony_type: PonyType):
	flying = false
	pony_type = in_pony_type
	if pony_sprite_by_type.has(pony_type):
		var found_sprite: SpriteFrames = pony_sprite_by_type[pony_type]
		if found_sprite is SpriteFrames:
			var flip_h: bool = sprite.flip_h
			var animation: StringName = sprite.animation
			sprite.sprite_frames = found_sprite
			sprite.flip_h = flip_h
			sprite.play(animation)
	if pony_type == PonyType.Pegasus:
		set_collision_mask_value(2, true)


func add_state(state: PonyStateMachine):
	pony_states |= (0b1 << state)


func remove_state(state: PonyStateMachine):
	pony_states &= ~(0b1 << state)


func has_state(state: PonyStateMachine) -> bool:
	return pony_states & (0b1 << state)


func highest_set_bit_index_fast(x: int) -> int:
	if x == 0:
		return -1
	var mask = 1 << 7
	var idx = 0
	while (x & mask) == 0:
		mask >>= 1
		idx += 1
	return 7 - idx


func _change_pony():
	pony_type = (pony_type + 1) % PonyType.Max as PonyType
	set_pony_type(pony_type)
	swap_sound.play()
	if smoke:
		var smoke_inst: Smoke = smoke.instantiate()
		var smoke_light_inst: Smoke = smoke.instantiate()
		Global.root.current_scene.add_child(smoke_inst)
		Global.root.current_scene.add_child(smoke_light_inst)
		smoke_inst.global_position = global_position
		smoke_light_inst.global_position = global_position
		smoke_light_inst.rotate(deg_to_rad(45))
		var animation: String = PonyType.keys()[pony_type]
		smoke_inst.sprite.play(animation)
		smoke_light_inst.sprite.play_backwards(animation + "Light")


func _on_hurt_timer_timeout() -> void:
	sprite.modulate = Color.WHITE


func _on_blink_timer_timeout() -> void:
	if recovery_timer.is_stopped():
		visible = true
		blink_timer.stop()
	else:
		visible = not visible
