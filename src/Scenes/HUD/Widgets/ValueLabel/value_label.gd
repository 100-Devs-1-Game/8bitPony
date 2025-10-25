@tool
class_name ValueLabel
extends HBoxContainer

@export var prefix: String:
	set(text):
		prefix = text
		if $Prefix:
			$Prefix.text = prefix
@export var value: Variant:
	set(new_value):
		value = new_value
		if $Value:
			$Value.text = str(value)
@export var suffix: String:
	set(text):
		suffix = text
		if $Suffix:
			$Suffix.text = suffix

@onready var prefix_label: Label = $Prefix
@onready var value_label: Label = $Value
@onready var suffix_label: Label = $Suffix


func _ready() -> void:
	prefix_label.text = prefix
	value_label.text = str(value)
	suffix_label.text = suffix
