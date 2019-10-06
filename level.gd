extends Node2D

export var next_level_name = "level_1"
export var floor_speed = 50

var player
var floor_obj
var end_zone
var floor_timer
var floor_active = false
var animations

func _ready():
	player = find_node("player")
	player.connect("hit_floor", self, "player_died")
	floor_obj = find_node("floor")
	end_zone = find_node("end_zone")
	end_zone.connect("body_entered", self, "end_zone_activated")

	game_state.connect("hit_enemy", self, "player_died")

	floor_timer = find_node("floor_timer")
	floor_timer.connect("timeout", self, "start_floor")

	animations = find_node("animations")
	animations.connect("animation_finished", self, "animation_finished")


func _physics_process(delta):
	if (!game_state.paused and floor_active):
		floor_obj.position.y = floor_obj.position.y - (floor_speed * delta)


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
		game_state.next_level_name = next_level_name
		get_tree().change_scene_to(level_end_scene)
