extends RichTextLabel

var delay = 0.05
var delay_timer = 0.2

func _ready() -> void:
	visible_characters = 0

func _physics_process(delta: float) -> void:
	delay_timer -= delta
	if delay_timer <=0:
		visible_characters +=1
		delay_timer = delay
