extends "res://Scripts/level.gd"


const DIAMOND_DOG = preload("uid://rbryiolfbe15")
const FLYING_ENEMY = preload("uid://c7mnvl4ns7f5u")
const ROLLING_ENEMY_SPAWNER = preload("uid://cbkcqlff2hu2y")
const WOLF = preload("uid://c4xpqd83w51cq")

@onready var spawns = $EnemySpawns.get_children()
	


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	$Boss.spawn_enemies.connect(spawn_enemies)
	spawns.shuffle()


func spawn_enemies():
	for i in range(randi_range(2, 4)):
		if spawns.size()==0: return
		var sp = spawns.pop_back()
		
		if sp.is_in_group("AirSpawn"):
			var enemy = FLYING_ENEMY.instantiate()
			enemy.global_position = sp.global_position
			get_tree().current_scene.add_child(enemy)
		
		if sp.is_in_group("GroundSpawn"):
			var rand_enemy = randi_range(1, 2)
			if rand_enemy==1:
				var enemy = DIAMOND_DOG.instantiate()
				enemy.global_position = sp.global_position
				get_tree().current_scene.add_child(enemy)
			elif rand_enemy==2:
				var enemy = WOLF.instantiate()
				enemy.global_position = sp.global_position
				get_tree().current_scene.add_child(enemy)
			
