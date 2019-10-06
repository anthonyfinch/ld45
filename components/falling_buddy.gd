extends KinematicBody2D

export var y_vel = 0
export var gravity = 200
export var x_vel = 200

var floor_normal = Vector2(0, -1)

var x_dir

func _physics_process(delta):
	y_vel = y_vel - (gravity * delta) * -1 
	var movement = Vector2(x_vel * x_dir, y_vel)

	move_and_slide(movement, floor_normal)

	if (is_on_floor()):
