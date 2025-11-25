extends Node2D

@onready var a: Marker2D = $A
@onready var b: Marker2D = $B
@onready var platform: TileMapLayer = $MovingPlatform

@export_range(0.25, 3.0, 0.05) var SpeedModifier: float = 1.0

var progress = 0.0:
	set(value):
		progress = wrapf(value, 0.0, 10.0)

func _process(delta: float) -> void:
	progress += delta * SpeedModifier / 3.0
	platform.position = a.position.lerp(b.position, pingpong(progress, 1.0))
