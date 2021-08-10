# Display the landing screen
extends MarginContainer

var _main_scene = preload("res://scenes/Main.tscn")


# Switch to main scene after displaying the landing screen
func _ready():
	yield(get_tree().create_timer(3.0), "timeout")
	get_tree().change_scene_to(_main_scene)
