extends MarginContainer

var display_scene = preload("res://scenes/Display.tscn")

func _ready():
	yield(get_tree().create_timer(3.0), "timeout")
	get_tree().change_scene_to(display_scene)
