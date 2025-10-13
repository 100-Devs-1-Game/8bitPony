class_name Player
extends CharacterBody2D

@onready var spr_player: Node2D = $player_sprite
@onready var un_anim_spr: AnimatedSprite2D = $player_sprite/Un_anim_sprite
@onready var state_label: Label = $State

# Sounds
@onready var hit_sound: AudioStreamPlayer = $Hit
@onready var health_sound: AudioStreamPlayer = $Health

@export var magic_bullet: PackedScene
@export var speed: float = 600.0
@export var jump_velocity: float = -550.0
@export var gravity_change: float = 200

enum PonyStateMachine {Idle, Run, Jump, Fall, Attack, Die}
var pony_state: PonyStateMachine = PonyStateMachine.Idle

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = gravity_change + ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	Global.face_right = true

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
		bullet.position.y = self.position.y -108
		
		if Global.face_right == true:
			bullet.position.x = self.position.x +70
		else:
			bullet.position.x = self.position.x -70
			
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
	var hurt_time = 0.2
	un_anim_spr.modulate = Color(1, 0, 0) #Red
	await get_tree().create_timer(hurt_time).timeout
	un_anim_spr.modulate = Color(1, 1, 1) #Return to normal
	
	
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
	if pony_state == PonyStateMachine.Fall:
		if spr_player.scale.x == 1:
			spr_player.rotation_degrees = -34
		elif spr_player.scale.x == -1:
			spr_player.rotation_degrees = 34
	else:
		spr_player.rotation_degrees = 0

	if pony_state != PonyStateMachine.Die:
		if Input.is_action_just_pressed("Right"):
			Global.face_right = true
			Global.face_left = false
			spr_player.scale.x = 1
		elif Input.is_action_just_pressed("Left"):
			spr_player.scale.x = -1
			Global.face_right = false
			Global.face_left = true
	match pony_state:
		PonyStateMachine.Attack:
			un_anim_spr.play("Attack")
		PonyStateMachine.Idle:
			un_anim_spr.play("Idle")
		PonyStateMachine.Run:
			un_anim_spr.play("Run")
		PonyStateMachine.Fall:
			un_anim_spr.play("Fall")
		PonyStateMachine.Die:
			un_anim_spr.play("Die")

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
