extends KinematicBody2D

export var move_speed = 150
export var jump_speed = 350
export var jump_gravity = 550
export var fall_gravity = 900

var y_vel = 0
var height = 32
var floor_normal = Vector2(0, -1)
var shake_amount = 5
var shake_time_total = 1.5
var last_x = -1

var shake_time = 0

var buddies
var collision_shape
var camera

var falling_buddy_scene = preload("res://components/falling_buddy.tscn")

signal hit_floor
signal thrown_buddy(buddy, position)


func _ready():
	buddies = find_node("buddies")
	collision_shape = find_node("collision_shape")
	camera = find_node("camera")


func _input(event):
	if !game_state.paused:
		if event.is_action_pressed("jump"):
			if is_on_floor():
				y_vel = jump_speed

		if event.is_action_pressed("throw"):
			if buddies_count() > 0:
				var thrown_buddy = buddies.get_child(buddies_count() - 1)
				var new_position = thrown_buddy.global_position
				buddies.remove_child(thrown_buddy)
				calculate_collision_shape()
				var falling_buddy = falling_buddy_scene.instance()
				thrown_buddy.position.y = 0
				falling_buddy.add_sprite(thrown_buddy)
				falling_buddy.x_dir = last_x
				emit_signal("thrown_buddy", falling_buddy, new_position)


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

		if (movement.x > 0):
			last_x = 1
		elif (movement.x < 0):
			last_x = -1

		move_and_slide(movement, floor_normal)

		for i in get_slide_count():
			var collision = get_slide_collision(i)
			if (collision.collider.name == "floor"):
				emit_signal("hit_floor")

		if (shake_time > 0):
			shake_time = shake_time - delta
			var shake_vec = Vector2(
				rand_range(-1.0, 1.0) * shake_amount,
				rand_range(-1.0, 1.0) * shake_amount
			)
			camera.set_offset(shake_vec)


func buddies_count():
	return buddies.get_child_count()


func add_buddy(sprite):
	buddies.add_child(sprite)
	sprite.position.x = 0
	sprite.position.y = -1 * buddies_count() * height
	calculate_collision_shape()


func calculate_collision_shape():
	collision_shape.position.y = -1 * buddies_count() * (height / 2)
	collision_shape.shape.extents.y = (buddies_count() + 1) * (height / 2) - 2


func shake():
	shake_time = shake_time_total
