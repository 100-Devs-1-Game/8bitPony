class_name Enemy
extends CharacterBody2D

@export var life: float = 1

func take_damage(damage: float = 1):
	life = max(0, life - damage)
	if life <= 0:
		queue_free()
