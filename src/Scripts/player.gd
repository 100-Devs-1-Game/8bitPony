class_name Player
extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var state_label: Label = $State
@onready var bullet_anchor: Node2D = $BulletAnchor

# Sounds
@onready var hit_sound: AudioStreamPlayer = $Hit
@onready var health_sound: AudioStreamPlayer = $Health

@export var magic_bullet: PackedScene
@export var speed: float = 600.0
@export var jump_velocity: float = -550.0
@export var gravity_change: float = 200
@export var hurt_time: float = 0.2

enum PonyStateMachine {Idle, Run, Jump, Fall, Attack, Die}
var pony_state: PonyStateMachine = PonyStateMachine.Idle

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = gravity_change + ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	_default_movement(delta) #handles the movement
	_pony_state_setter()
	_sprite_handle()
	_state_label_tect()

func _default_movement(_delta: float): #player moment from the character2d script
		# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * _delta
	
	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = jump_velocity
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("Left", "Right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	move_and_slide()

func _input(_event: InputEvent):
	#Firing magic bullets
	if Input.is_action_just_pressed("Shoot"):
		var bullet =  magic_bullet.instantiate()
		if bullet is MagicBullet:
			bullet.global_position = bullet_anchor.global_position
			if sprite.flip_h:
				bullet.velocity = -bullet.velocity
		get_parent().add_child(bullet)
		print("shoot")

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

func _pony_state_setter():
	if pony_state == PonyStateMachine.Die:
		return  # death overrides everything
	
	# --- In the air ---
	if not is_on_floor():
		if velocity.y < 0:
			pony_state = PonyStateMachine.Jump
		else:
			pony_state = PonyStateMachine.Fall
		return  # stop here so we don't fall through
	
	# --- On the ground ---
	if Input.is_action_pressed("Attack"):
		pony_state = PonyStateMachine.Attack
	elif abs(velocity.x) > 0.1:
		pony_state = PonyStateMachine.Run
	else:
		pony_state = PonyStateMachine.Idle

func _sprite_handle(): #handles sprite stuff
	if pony_state != PonyStateMachine.Die:
		if Input.is_action_just_pressed("Right"):
			sprite.flip_h = false
			bullet_anchor.position.x = max(-bullet_anchor.position.x, bullet_anchor.position.x)
		elif Input.is_action_just_pressed("Left"):
			sprite.flip_h = true
			bullet_anchor.position.x = min(-bullet_anchor.position.x, bullet_anchor.position.x)
	match pony_state:
		PonyStateMachine.Attack:
			sprite.play("Attack")
		PonyStateMachine.Idle:
			sprite.play("Idle")
		PonyStateMachine.Run:
			sprite.play("Run")
		PonyStateMachine.Fall:
			sprite.play("Fall")
		PonyStateMachine.Die:
			sprite.play("Die")

func _state_label_tect():
	#visual tracker of the state
	match pony_state: 
		PonyStateMachine.Idle:
			state_label.text = str("Idle")
		PonyStateMachine.Run:
			state_label.text = str("Run")
		PonyStateMachine.Jump:
			state_label.text = str("Jump")
		PonyStateMachine.Fall:
			state_label.text = str("Fall")
		PonyStateMachine.Attack:
			state_label.text = str("Attack")
		PonyStateMachine.Die:
			state_label.text = str("Die")
