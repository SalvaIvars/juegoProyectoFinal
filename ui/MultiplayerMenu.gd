extends Control

func _ready():
	pass # Replace with function body.

func _on_Play_pressed():
	get_tree().change_scene("res://Client/scenes/main.tscn")

func _on_Create_pressed():
	var output = []
	var path = OS.get_executable_path().get_base_dir() + "/Server/server.exe"
	OS.execute(path, [],false )
	get_tree().change_scene("res://Client/scenes/main.tscn")

func _on_Quit_pressed():
	get_tree().change_scene("res://ui/menu/MainMenu.tscn")
