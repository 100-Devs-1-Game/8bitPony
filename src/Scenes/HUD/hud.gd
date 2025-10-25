@tool
extends CanvasLayer

@onready var score: ValueLabel = $Gui/Stats/ScoreValue
@onready var level_shards: ValueLabel = $Gui/Stats/Shards/ShardValue
@onready var health: ValueLabel = $Gui/HealthValue


func _ready() -> void:
	score.value = Global.player.score
	level_shards.value = Global.shard_counter
	health.value = Global.player.health
	Global.player.score_changed.connect(_on_score_changed)
	Global.shard_value_changed.connect(_on_shard_changed)
	Global.player.health_changed.connect(_on_health_changed)


func _on_score_changed(new_score: int):
	score.value = new_score


func _on_shard_changed(new_value: int):
	level_shards.value = new_value

func _on_health_changed(new_health: int):
	health.value = new_health
