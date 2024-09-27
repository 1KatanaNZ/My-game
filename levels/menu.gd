extends Control

func _ready():
	$VBoxContainer/Start.grab_focus()


func _on_play_pressed():
	get_tree().change_scene_to_file("res://levels/level_1.tscn")



func _on_exit_pressed():
	get_tree().quit()
