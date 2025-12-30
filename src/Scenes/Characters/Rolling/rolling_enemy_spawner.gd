extends Node2D

const ROLLING_ENEMY = preload("uid://domwhgmohvhfa")
@export var time_bewteen_spawns:float = 5
@export_enum("left", "right") var roll_direction = "left"
@export_enum("log", "boulder", "cookie") var sprite_type = "log"

@onready var current_timer = time_bewteen_spawns

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	current_timer += delta
	
	if current_timer >= time_bewteen_spawns:
		var e = ROLLING_ENEMY.instantiate()
		e.roll_direction = roll_direction
		e.sprite_type = sprite_type
		e.position = Vector2.ZERO
		add_child(e)
		current_timer = 0
