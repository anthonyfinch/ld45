extends Node2D

var level_path = "res://%s.tscn"

func _input(event):
	if event.is_pressed():
		var next_level = load(level_path % game_state.next_level_name)
		game_state.paused = false
		get_tree().change_scene_to(next_level)
