extends Area2D

var sprite

export var frame = 1

func _ready():
	sprite = find_node("sprite")
	sprite.frame = frame
	connect("body_entered", self, "player_collide")


func set_frame(frame):
	frame = frame
	sprite.frame = frame


func player_collide(body):
	if (body.name == "player"):
		remove_child(sprite)
		body.add_buddy(sprite)
		queue_free()
