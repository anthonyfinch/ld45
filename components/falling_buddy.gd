extends KinematicBody2D

export var y_vel = 0
export var gravity = 200
export var x_vel = 200

var floor_normal = Vector2(0, -1)
var sprite

var x_dir

func add_sprite(sprite):
	self.sprite = sprite
	add_child(sprite)

func _physics_process(delta):
	y_vel = y_vel - (gravity * delta) * -1 
	var movement = Vector2(x_vel * x_dir, y_vel)

	move_and_slide(movement, floor_normal)

	if (is_on_wall()):
		x_vel = 0

	if (is_on_floor()):
		game_state.emit_signal("buddy_landed", self, self.global_position, self.sprite.frame)
		queue_free()
