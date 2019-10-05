extends Area2D


func _ready():
	connect("body_entered", self, "hit_player")


func hit_player(body):
	if (body.name == "player"):
		print("hit player")
		game_state.emit_signal("hit_enemy")
