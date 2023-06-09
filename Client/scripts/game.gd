extends Node

onready var main_scene = get_tree().root.get_child(get_tree().root.get_child_count() - 1)
onready var world = main_scene.get_node("world")
var gameWinner = ""
var is_paused = false
var numberOfGames = 0
var movement_inverted = false
var INVERSION = -1

func _ready():
	pass

func _change_to_main():
	get_tree().root.remove_child(main_scene)
	get_tree().change_scene("res://Client/scenes/main.tscn")

func set_name(value):
	gameWinner = value

func set_is_paused(value):
	is_paused = value

func add_number_of_games():
	numberOfGames+=1

func change_movement():
	movement_inverted = true

func change_inversion():
	INVERSION = 1
	
func back_to_normal():
	INVERSION = -1
	movement_inverted = false
