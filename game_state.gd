extends Node

var paused = false

var next_level_name
var last_level = "0"
var scores = {}
var running_total = 0

signal hit_enemy
signal buddy_landed(buddy, position, frame)
