extends Control

var level_instance : Spatial
onready var main_3d : Spatial = $Main3D
onready var background : ColorRect = $Background
onready var center : CenterContainer= $CenterContainer
onready var levelChangeAnimation : AnimationPlayer = $AnimationPlayer
onready var levelChangeColorRect : ColorRect = $LevelAnimation
onready var first_world = preload("res://Levels/Worlds/Level1.tscn")
onready var second_world = preload("res://Levels/Worlds/Level1.tscn")

func _ready():
	levelChangeColorRect.hide()

func _on_Play_pressed():
	#get_tree().change_scene("res://Levels/Worlds/Level1.tscn")
	load_level("Level1")

func _on_Quit_pressed():
	get_tree().quit()

func _on_Level_pressed():
	get_tree().change_scene("res://ui/menu/LevelMenu.tscn")

func unload_level():
	if(is_instance_valid(level_instance)):
		level_instance.queue_free()
	level_instance = null
	
func load_level(level_name : String):
	unload_level()
	#var level_path := "res://Levels/Worlds/%s.tscn" % level_name
	#var level_resource := load(level_path)
	var level_resource = first_world
	if (level_resource):
		background.hide()
		center.hide()
		level_instance = level_resource.instance()
		levelChangeColorRect.show()
		$AnimationPlayer.play("ChangeLevel")
		yield(get_tree().create_timer(2), "timeout")
		main_3d.add_child(level_instance)
		levelChangeColorRect.hide()
