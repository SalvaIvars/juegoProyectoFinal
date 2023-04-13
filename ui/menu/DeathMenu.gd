extends Control

var is_paused = false setget set_is_paused

func set_is_paused(value):
	is_paused = value
	get_tree().paused = is_paused
	visible = is_paused
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _on_Quit_pressed():
	get_tree().change_scene("res://ui/menu/MainMenu.tscn")


func _on_Restart_pressed():
	self.is_paused = false
	get_tree().reload_current_scene()
