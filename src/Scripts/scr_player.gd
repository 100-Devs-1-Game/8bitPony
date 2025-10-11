extends CharacterBody2D

const SPEED = 600.0
const JUMP_VELOCITY = -550.0
const Gravity_change = 200

enum pony_state_machine {Idle, Running, Jumping, Falling, Attacking, Dying}
var pony_state = pony_state_machine.Idle
@onready var spr_player = $spr_player
@onready var spr_u_idle = $spr_player/spr_unicorn_idle
@onready var spr_u_fall = $spr_player/spr_unicorn_fall
@onready var un_anim_spr = $spr_player/Un_anim_spr
@onready var state_label = $State_label

# Sounds
@onready var hit_sound = $Hit_sound
@onready var health_sound = $Health_sound

var MagicBullet: PackedScene = load("res://Scenes/Objects/obj_magic_bullet.tscn")


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = Gravity_change + ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	Global.face_right = true

func _physics_process(delta):
	_default_movement(delta) #handles the movement
	_Pony_state_setter()
	_sprite_handle()
	_state_label_tect()
	
func _default_movement(delta): #player moment from the character2d script
		# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("Up") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("Left", "Right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func _input(event):
	#Firing magic bullets
	if Input.is_action_just_pressed("Shoot"):
		var bullet =  MagicBullet.instantiate()
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
	
	
func _Pony_state_setter():
	if pony_state == pony_state_machine.Dying:
		return  # death overrides everything

	# --- In the air ---
	if not is_on_floor():
		if velocity.y < 0:
			pony_state = pony_state_machine.Jumping
		else:
			pony_state = pony_state_machine.Falling
		return  # stop here so we don't fall through

	# --- On the ground ---
	if Input.is_action_pressed("attack"):
		pony_state = pony_state_machine.Attacking
	elif abs(velocity.x) > 0.1:
		pony_state = pony_state_machine.Running
	else:
		pony_state = pony_state_machine.Idle


func _sprite_handle(): #handles sprite stuff
	if pony_state == pony_state_machine.Falling:
		if spr_player.scale.x == 1:
			spr_player.rotation_degrees = -34
		elif spr_player.scale.x == -1:
			spr_player.rotation_degrees = 34
	else:
		spr_player.rotation_degrees = 0

	if pony_state != pony_state_machine.Dying:
		if Input.is_action_just_pressed("Right"):
			Global.face_right = true
			Global.face_left = false
			spr_player.scale.x = 1
		elif Input.is_action_just_pressed("Left"):
			spr_player.scale.x = -1
			Global.face_right = false
			Global.face_left = true
	match pony_state: 
		pony_state_machine.Idle:
			un_anim_spr.play("Idle")
		pony_state_machine.Running:
			un_anim_spr.play("Running")
		pony_state_machine.Falling:
			un_anim_spr.play("Fall")
		pony_state_machine.Attacking:
			un_anim_spr.play("Idle")
		pony_state_machine.Dying:
			un_anim_spr.play("Dying")

func _state_label_tect():
	#visual tracker of the state
	match pony_state: 
		pony_state_machine.Idle:
			state_label.text = str("Idle")
		pony_state_machine.Running:
			state_label.text = str("Running")
		pony_state_machine.Jumping:
			state_label.text = str("Jumping")
		pony_state_machine.Falling:
			state_label.text = str("Fall")
		pony_state_machine.Attacking:
			state_label.text = str("Attack")
		pony_state_machine.Dying:
			state_label.text = str("Die")
