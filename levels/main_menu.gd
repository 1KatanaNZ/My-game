extends CanvasLayer

var GameManager

func _on_play_pressed():
	GameManager.start_game()
	queue_free()

func _on_exit_pressed() -> void:
	pass # Replace with function body.
