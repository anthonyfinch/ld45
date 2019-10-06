extends Node2D

var level_path = "res://%s.tscn"

func _ready():
	var buddy_score = find_node("buddy_score")
	var buddy_multiply = find_node("buddy_multiply")
	var total = find_node("total")

	if game_state.last_level in game_state.scores:
		var scores = game_state.scores[game_state.last_level]

		var b_score = scores.size()

		var b_mult = false
		var test_scores = scores.duplicate()
		test_scores.sort()
		if (test_scores == scores):
			b_mult = true

		var b_total = b_score * 100
		var g_total = b_total
		if b_mult:
			g_total = 2 * b_total

		buddy_score.text = "Buddies Rescued: %s = %s pts" % [b_score, b_total]
		if b_mult:
			buddy_multiply.text = "Buddies In Order Bonus!"
		else:
			buddy_multiply.text = "No Buddies In Order Bonus :("

		total.text = "Total Level Score: %s" % g_total


func _input(event):
	if event.is_pressed():
		var next_level = load(level_path % game_state.next_level_name)
		game_state.paused = false
		get_tree().change_scene_to(next_level)
