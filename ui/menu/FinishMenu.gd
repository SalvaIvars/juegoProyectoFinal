extends Control

onready var options = get_node("/root/GlobalSettings")

func _ready():
	$CenterContainer/VBoxContainer/Label2.text = str(options.points) + " points"


func _on_Play_pressed():
	get_tree().change_scene("res://ui/menu/MainMenu.tscn")

func _on_Quit_pressed():
	get_tree().quit()


