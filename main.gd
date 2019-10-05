extends Node2D

export var floor_speed = 50

var player
var floor_obj
var end_zone

func _ready():
	player = find_node("player")
	player.connect("hit_floor", self, "player_died")
	floor_obj = find_node("floor")
	end_zone = find_node("end_zone")
	end_zone.connect("body_entered", self, "end_zone_activated")


func _physics_process(delta):
	if !game_state.paused:
		floor_obj.position.y = floor_obj.position.y - (floor_speed * delta)


func player_died():
	var intro_scene = load("res://intro.tscn")
	game_state.paused = true
	get_tree().change_scene_to(intro_scene)


func end_zone_activated(body):
	if (body.name == "player"):
		var level_end_scene = load("res://level_end.tscn")
		game_state.paused = true
		get_tree().change_scene_to(level_end_scene)
