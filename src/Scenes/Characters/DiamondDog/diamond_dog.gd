extends Enemy

var direction = 1
var old_direction = 1
var speed = 10
var shoot_time = 1.5 #seconds
var shoot_timer = 0

var player_in_area = false

@onready var detect_player: Area2D = $detectPlayer
@onready var bullet_spawn: Node2D = $detectPlayer/bulletSpawn
@onready var sprite2D: AnimatedSprite2D = $AnimatedSprite2D



const ENEMY_BULLET = preload("uid://m3guooh6xn5o")


func _physics_process(_delta: float) -> void:
	shoot_timer +=_delta
	velocity.x = direction * speed
	if velocity.x > 0: detect_player.rotation_degrees = 180
	elif velocity.x < 0: detect_player.rotation_degrees = 0
	
	if player_in_area and shoot_timer>=shoot_time:
		shoot_timer = 0
		var new_bullet = ENEMY_BULLET.instantiate()
		new_bullet.global_position = bullet_spawn.global_position
		new_bullet.velocity = old_direction
		get_tree().current_scene.add_child(new_bullet)

	move_and_slide()
	

func _on_detect_floor_body_exited(_body: Node2D) -> void:
	direction *= -1


func _on_detect_wall_body_entered(_body: Node2D) -> void:
	direction *= -1
	


func _on_detect_player_body_entered(_body: Node2D) -> void:
	print("Shoot at player")
	sprite2D.animation = "idle"
	player_in_area = true
	old_direction = direction
	direction = 0


func _on_detect_player_body_exited(body: Node2D) -> void:
	print("Stop shooting")
	sprite2D.animation = "walk"
	player_in_area = false
	direction = old_direction
