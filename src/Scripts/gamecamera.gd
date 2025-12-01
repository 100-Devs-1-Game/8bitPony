extends Camera2D

var player
var camrect = Rect2()

func _ready() -> void:
	camrect.position = get_target_position() - get_viewport_rect().size / 2
	camrect.size = get_viewport_rect().size

func _process(_delta: float) -> void:
	if !player: 
		player = get_tree().get_first_node_in_group("player")
		if !player: return
	if camrect.has_point(player.global_position):
		enabled = true
	else:
		enabled = false
