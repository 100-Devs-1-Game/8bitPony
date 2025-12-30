extends "res://Scripts/level.gd"


const DIAMOND_DOG = preload("uid://rbryiolfbe15")
const WOLF = preload("uid://c4xpqd83w51cq")
const LIZARD = preload("uid://qp8eqjo46ts5")
const SUGAR_LIZARD = preload("uid://dykxecn6lk5yr")
const WIZARD = preload("uid://xdo38ijici1p")



const FLYING_ENEMY = preload("uid://c7mnvl4ns7f5u")
const OWL = preload("uid://cgip5o63lpxrk")
const BAT = preload("uid://dvkl266xaxm4h")



var ground_enemy = [DIAMOND_DOG, WIZARD, WOLF, LIZARD, SUGAR_LIZARD]
var flying_enemy = [FLYING_ENEMY, OWL, BAT]

@onready var spawns = $EnemySpawns.get_children()
	


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	$Boss.spawn_enemies.connect(spawn_enemies)
	spawns.shuffle()
	Music.play_music(7)


func spawn_enemies():
	for i in range(randi_range(2, 4)):
		if spawns.size()==0: return
		var sp = spawns.pop_back()
		
		if sp.is_in_group("AirSpawn"):
			var enemy = flying_enemy[randi_range(0,2)].instantiate()
			enemy.global_position = sp.global_position
			get_tree().current_scene.add_child(enemy)
		
		if sp.is_in_group("GroundSpawn"):
			var enemy =ground_enemy[randi_range(0,4)].instantiate()
			enemy.global_position = sp.global_position
			get_tree().current_scene.add_child(enemy)

			
