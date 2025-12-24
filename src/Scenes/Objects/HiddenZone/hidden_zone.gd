extends Area2D

@export var layer: Node2D
@export var end_alpha: float = 0.2
@export var transition_time: float = 0.2

var start_alpha: float
var target_alpha: float


func _ready() -> void:
	start_alpha = layer.modulate.a
	target_alpha = start_alpha


func _process(_delta: float) -> void:
	if layer.modulate.a != target_alpha:
		layer.modulate.a = lerp(layer.modulate.a, target_alpha, transition_time)


func _on_body_entered(_body: Node2D) -> void:
		target_alpha = end_alpha


func _on_body_exited(_body: Node2D) -> void:
		target_alpha = start_alpha
