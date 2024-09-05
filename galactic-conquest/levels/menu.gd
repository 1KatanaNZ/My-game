extends Control

func _ready():
	$VBoxContainer/Start.grab_focus()


func _on_start_pressed():
	get_tree().change_scene_to_file("res://levels/test levels/test_level.tscn")


func _on_options_pressed():
	var options = load("res://levels/options.tscn")
	get_tree().current_scene.add_child(options)

func _on_quit_pressed():
	get_tree().quit()
