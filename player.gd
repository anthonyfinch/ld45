extends KinematicBody2D

export var move_speed = 150
export var jump_speed = 350
export var jump_gravity = 500
export var fall_gravity = 800

var y_vel = 0

var floor_normal = Vector2(0, -1)

func _input(event):
	if event.is_action_pressed("jump"):
		print("jumped")
		if is_on_floor():
			y_vel = jump_speed

func _physics_process(delta):

	var movement = Vector2(0,0)
	if Input.is_action_pressed("move_left"):
		movement.x = -1 * move_speed
	if Input.is_action_pressed("move_right"):
		movement.x = move_speed

	if !is_on_floor():
		print("not on floor")
		if y_vel > 0:
			if is_on_ceiling():
				y_vel = 0
			y_vel = y_vel - (jump_gravity * delta)
			print("jumpfall")
		else:
			y_vel = y_vel - (fall_gravity * delta)
			print("FAALING")
		movement.y = -1 * y_vel

	else:
		print("on floor")
		movement.y = -1 * y_vel

	move_and_slide(movement, floor_normal)