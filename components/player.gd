extends KinematicBody2D

export var move_speed = 150
export var jump_speed = 350
export var jump_gravity = 550
export var fall_gravity = 900

var y_vel = 0
var height = 32
var floor_normal = Vector2(0, -1)

var buddies
var collision_shape

signal hit_floor


func _ready():
	buddies = find_node("buddies")
	collision_shape = find_node("collision_shape")

func _input(event):
	if !game_state.paused:
		if event.is_action_pressed("jump"):
			if is_on_floor():
				y_vel = jump_speed

func _physics_process(delta):
	if !game_state.paused:
		var movement = Vector2(0,0)
		if Input.is_action_pressed("move_left"):
			movement.x = -1 * move_speed
		if Input.is_action_pressed("move_right"):
			movement.x = move_speed

		if !is_on_floor():
			if y_vel > 0:
				if is_on_ceiling():
					y_vel = 0
				y_vel = y_vel - (jump_gravity * delta)
			else:
				y_vel = y_vel - (fall_gravity * delta)

		else:
			if y_vel <= 0:
				y_vel = -10

		movement.y = -1 * y_vel

		move_and_slide(movement, floor_normal)

		for i in get_slide_count():
			var collision = get_slide_collision(i)
			if (collision.collider.name == "floor"):
				emit_signal("hit_floor")


func add_buddy(sprite):
	buddies.add_child(sprite)
	var buddies_count = buddies.get_child_count()
	sprite.position.x = 0
	sprite.position.y = -1 * buddies_count * height

	collision_shape.position.y = -1 * buddies_count * (height / 2)
	collision_shape.shape.extents.y = (buddies_count + 1) * 16
