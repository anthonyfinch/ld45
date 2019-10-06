extends Node2D

export var level_name = "base_level"
export var next_level_name = "level_1"
export var floor_speed = 60

var player
var floor_obj
var end_zone
var floor_timer
var floor_active = false
var animations
var buddies

var buddy_scene = preload("res://components/buddy.tscn")

func _ready():
	player = find_node("player")
	player.connect("hit_floor", self, "player_died")
	player.connect("thrown_buddy", self, "add_falling_buddy")

	floor_obj = find_node("floor")

	end_zone = find_node("end_zone")
	end_zone.connect("body_entered", self, "end_zone_activated")

	game_state.connect("hit_enemy", self, "player_died")
	game_state.connect("buddy_landed", self, "buddy_landed")

	floor_timer = find_node("floor_timer")
	floor_timer.connect("timeout", self, "start_floor")

	animations = find_node("animations")
	animations.connect("animation_finished", self, "animation_finished")

	buddies = find_node("buddies_container")


func _physics_process(delta):
	if (!game_state.paused and floor_active):
		floor_obj.position.y = floor_obj.position.y - (floor_speed * delta)


func add_falling_buddy(buddy, position):
	buddies.add_child(buddy)
	buddy.global_position = position


func buddy_landed(buddy, position, frame_no):
	var landed_buddy = buddy_scene.instance()
	buddies.add_child(landed_buddy)
	landed_buddy.global_position = position
	landed_buddy.set_frame(frame_no)


func start_floor():
	player.shake()
	floor_active = true


func player_died():
	game_state.paused = true
	animations.play("die")

func end_zone_activated(body):
	if (body.name == "player"):
		game_state.paused = true
		animations.play("win")


func animation_finished(anim):
	if (anim == "die"):
		var intro_scene = load("res://intro.tscn")
		get_tree().change_scene_to(intro_scene)

	if (anim == "win"):
		var level_end_scene = load("res://level_end.tscn")
		var scores = []
		for buddy in player.buddies.get_children():
			scores.push_back(buddy.frame)

		game_state.scores[level_name] = scores
		game_state.last_level = level_name
		game_state.next_level_name = next_level_name
		get_tree().change_scene_to(level_end_scene)
