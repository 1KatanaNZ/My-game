extends Node

var level_1 = preload("res://levels/level_1.tscn")

func _ready():
	RenderingServer.set_default_clear_color(Color(0.44,0.12,0.53,1.00))


func start_game():
	transition_to_scene(level_1.resource_path)


func transition_to_scene(scene_path):
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file(scene_path)
