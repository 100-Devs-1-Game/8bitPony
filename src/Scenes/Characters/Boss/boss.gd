extends CharacterBody2D

@onready var tail: Area2D = $Tail
@onready var torso: Area2D = $Torso
@onready var arm_r: Area2D = $ArmR
@onready var arm_l: Area2D = $ArmL
@onready var leg_l: Area2D = $LegL
@onready var leg_r: Area2D = $LegR
@onready var head: Area2D = $Head
@onready var parts = [head, torso, tail, leg_l, leg_r, arm_l, arm_r]
@onready var anim: AnimationPlayer = $AnimationPlayer

enum Body{head, torso, tail, leg_l, leg_r, arm_l, arm_r}
var part_life = [5, 5, 5, 5, 5, 5, 5]

const ENEMY_BULLET = preload("uid://m3guooh6xn5o")

var direction = Vector2.ZERO
var in_stomp_area:bool = false
var speed = 10

signal spawn_enemies

func _ready() -> void:
	tail.area_entered.connect(body_part_hit.bind(Body.tail))
	torso.area_entered.connect(body_part_hit.bind(Body.torso))
	arm_r.area_entered.connect(body_part_hit.bind(Body.arm_r))
	arm_l.area_entered.connect(body_part_hit.bind(Body.arm_l))
	leg_r.area_entered.connect(body_part_hit.bind(Body.leg_r))
	leg_l.area_entered.connect(body_part_hit.bind(Body.leg_l))
	head.area_entered.connect(body_part_hit.bind(Body.head))
	
	tail.body_entered.connect(body_part_entered)
	torso.body_entered.connect(body_part_entered)
	arm_r.body_entered.connect(body_part_entered)
	arm_l.body_entered.connect(body_part_entered)
	leg_r.body_entered.connect(body_part_entered)
	leg_l.body_entered.connect(body_part_entered)
	head.body_entered.connect(body_part_entered)


func _physics_process(delta: float) -> void:
	velocity = direction.normalized() * speed
	
	move_and_slide()


func body_part_hit(area, part):
	area.queue_free()
	#Cant kill tail unil both legs are gone
	if part == Body.tail:
		if parts[Body.leg_l].visible or parts[Body.leg_r].visible: return
	
	#Cant kill torso until all limbs are gon
	if part == Body.torso:
		if parts[Body.leg_l].visible or parts[Body.leg_r].visible or\
		 parts[Body.arm_r].visible or parts[Body.arm_l].visible or parts[Body.tail].visible: return
	
	#Cant kill head until torso is gone
	if part==Body.head:
		if parts[Body.torso].visible: return
		
	
	part_life[part] -=1
	var tw = create_tween()
	tw.tween_property(parts[part], "modulate", Color(1.0, 0.0, 0.0, 1.0), 0.25)
	tw.tween_property(parts[part], "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.25)
	
	if part_life[part]<=0:
		set_part_disabled(true, part)
	
		if part == Body.leg_l or part==Body.leg_r and part_life[Body.tail]>0:
			set_part_disabled(false, Body.tail)
		
		if part == Body.head:
			get_tree().change_scene_to_file("res://Scenes/End.tscn")
	
	
	
func body_part_entered(body: CharacterBody2D):
	body.take_damage()

func set_part_disabled(value, part):
	if value:
		parts[part].hide()
		parts[part].get_node("CollisionShape2D").set_deferred("disabled", true)
		anim.play("spawn_enemies")
		

		if parts[part].has_node("hurt_player_area"):
			parts[part].get_node("hurt_player_area/CollisionShape2D").set_deferred("disabled", true)
	else:
		parts[part].show()
		parts[part].get_node("CollisionShape2D").set_deferred("disabled", false)


func shoot_bullet_R():
	if not parts[Body.arm_r].visible: return
	
	var bullet:Area2D = ENEMY_BULLET.instantiate()
	bullet.global_position = $ArmR/bullet_spawn.global_position
	bullet.direction = Global.player.global_position - bullet.global_position
	get_tree().current_scene.add_child(bullet)

func shoot_bullet_L():
	if not parts[Body.arm_l].visible: return
	
	var bullet:Area2D = ENEMY_BULLET.instantiate()
	bullet.global_position = $ArmL/bullet_spawn.global_position
	bullet.direction = Global.player.global_position - bullet.global_position
	get_tree().current_scene.add_child(bullet)

func spawn_enemy():
	spawn_enemies.emit()

func _on_hurt_player_area_body_entered(body: Node2D) -> void:
	body.take_damage()


func _on_stomp_area_body_entered(body: Node2D) -> void:
	in_stomp_area = true


func _on_stomp_area_body_exited(body: Node2D) -> void:
	in_stomp_area = false
	

func _on_attack_timer_timeout() -> void:
	print("Attack")
	if in_stomp_area and (parts[Body.leg_l].visible or parts[Body.leg_r].visible):
		print("Stomp")
		direction.x = Global.player.global_position.x - global_position.x
		direction.y = 0
		anim.play("stomp")
	elif parts[Body.arm_l].visible or parts[Body.arm_r].visible:
		anim.play("shoot_hand")
	else:
		anim.play("spawn_enemies")
	
	
