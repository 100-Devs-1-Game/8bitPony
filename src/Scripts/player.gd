class_name Player
extends CharacterBody2D

enum PonyType { Earth, Pegasus, Unicorn, Max }
enum PonyStateMachine { Idle, Run, Jump, Fall, Action, Die }

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var state_label: Label = $State
@onready var bullet_anchor: Node2D = $BulletAnchor
@onready var attack_timer: Timer = $AttackTimer

# Sounds
@onready var hit_sound: AudioStreamPlayer = $Hit
@onready var health_sound: AudioStreamPlayer = $Health

@export var magic_bullet: PackedScene
@export var speed: float = 600.0
@export var jump_velocity: float = -550.0
@export var gravity_change: float = 200
@export var attack_time: float = 10.0
@export var hurt_time: float = 0.2
@export var pony_type: PonyType = PonyType.Unicorn
@export var pony_sprite_by_type: Dictionary[PonyType, SpriteFrames]

var pony_states: int = PonyStateMachine.Idle

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = gravity_change + ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready() -> void:
	set_pony_type(pony_type)

func _process(_delta: float) -> void:
	_update_pony_state()
	_sprite_handle()
	_state_label_tect()

func _physics_process(delta):
	_default_movement(delta) #handles the movement

func _default_movement(_delta: float): #player moment from the character2d script
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * _delta
	
	var direction = Input.get_axis("Left", "Right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	
	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	#Firing magic bullets
	if event.is_action_pressed("Action"):
		var bullet =  magic_bullet.instantiate()
		if bullet is MagicBullet:
			bullet.global_position = bullet_anchor.global_position
			if sprite.flip_h:
				bullet.velocity = -bullet.velocity
		get_parent().add_child(bullet)
		add_state(PonyStateMachine.Action)
		attack_timer.start()
		print("shoot")
	elif event.is_action_pressed("Jump") and is_on_floor():
		velocity.y = jump_velocity
	elif event.is_action_pressed("ChangePony"):
		pony_type = (pony_type + 1) % PonyType.Max as PonyType
		set_pony_type(pony_type)

func _take_damage():
	Global.player_lives -= 1
	print("Player hit!")
	hit_sound.play()
	_flash_red()

func _life_pickup(): #pick up extra life
	Global.player_lives += 1
	print("Player hit!")
	health_sound.play()

func _flash_red(): #player gets hit, flash red
	sprite.modulate = Color(1, 0, 0) #Red
	await get_tree().create_timer(hurt_time).timeout
	sprite.modulate = Color(1, 1, 1) #Return to normal

func _update_pony_state():
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
	if attack_timer.is_stopped():
		remove_state(PonyStateMachine.Action)
	
	if abs(velocity.x) > 0.1:
		add_state(PonyStateMachine.Run)
		remove_state(PonyStateMachine.Idle)
	else:
		add_state(PonyStateMachine.Idle)
		remove_state(PonyStateMachine.Run)

func _sprite_handle(): #handles sprite stuff
	if not has_state(PonyStateMachine.Die):
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

func _state_label_tect():
	#visual tracker of the state
	match pony_states:
		PonyStateMachine.Idle:
			state_label.text = str("Idle")
		PonyStateMachine.Run:
			state_label.text = str("Run")
		PonyStateMachine.Jump:
			state_label.text = str("Jump")
		PonyStateMachine.Fall:
			state_label.text = str("Fall")
		PonyStateMachine.Action:
			state_label.text = str("Action")
		PonyStateMachine.Die:
			state_label.text = str("Die")

func set_pony_type(in_pony_type: PonyType):
	pony_type = in_pony_type
	if pony_sprite_by_type.has(pony_type):
		var found_sprite: SpriteFrames = pony_sprite_by_type[pony_type]
		if found_sprite is SpriteFrames:
			var flip_h: bool = sprite.flip_h
			var animation: StringName = sprite.animation
			sprite.sprite_frames = found_sprite
			sprite.flip_h = flip_h
			sprite.play(animation)

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
