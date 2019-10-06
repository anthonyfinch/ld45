extends Node2D


func _input(event):
	var level_scene = load("res://level_1.tscn")
	if event.is_pressed():
		game_state.paused = false
		get_tree().change_scene_to(level_scene)
