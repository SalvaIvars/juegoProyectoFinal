extends Control

var first_world = load("res://World.tscn")

func _on_Play_pressed():
	get_tree().change_scene("res://World.tscn")

func _on_Quit_pressed():
	get_tree().quit()

func _on_Level_pressed():
	get_tree().change_scene("res://ui/menu/LevelMenu.tscn")
