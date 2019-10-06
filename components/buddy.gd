extends Area2D

var sprite

func _ready():
	sprite = find_node("sprite")
	connect("body_entered", self, "player_collide")

func player_collide(body):
	if (body.name == "player"):
		remove_child(sprite)
		body.add_buddy(sprite)
		queue_free()
