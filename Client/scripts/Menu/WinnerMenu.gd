extends Control

var is_paused = false setget set_is_paused
var nameWinner : String

func _ready():
	set_name(game.gameWinner)
	set_is_paused(game.is_paused)
	game.is_paused = false

func set_is_paused(value):
	is_paused = value
	get_tree().paused = is_paused
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	var t = Timer.new()
	if value:
		yield(get_tree().create_timer(5.0), "timeout")
		game._change_to_main()

func set_name(value):
	nameWinner = str(value)
	get_node("Background/CenterContainer/VBoxContainer/Winner").text += nameWinner

