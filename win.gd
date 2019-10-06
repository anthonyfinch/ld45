extends Node2D

func _ready():
	var total_points = find_node("total_points")
	total_points.text = "total Points: %s" % game_state.running_total


func _input(event):
	if event.is_pressed():
		var next_level = load("res://intro.tscn")
		game_state.paused = false
		get_tree().change_scene_to(next_level)

