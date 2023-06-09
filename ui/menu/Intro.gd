extends Control

func _ready():
	OS.window_fullscreen = true
	$AnimationPlayer.play("ChangeLevel")
	yield(get_tree().create_timer(3), "timeout")
	$AnimationPlayer.play("FadeOut")
	yield(get_tree().create_timer(2), "timeout")
	get_tree().change_scene("res://ui/menu/MainMenu.tscn")
