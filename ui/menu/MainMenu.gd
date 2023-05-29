extends Control

var level_instance : Spatial
onready var main_3d : Spatial = $Main3D
onready var background : ColorRect = $Background
onready var center : CenterContainer= $CenterContainer
onready var levelChangeAnimation : AnimationPlayer = $AnimationPlayer
onready var levelChangeColorRect : ColorRect = $LevelAnimation
onready var first_world = preload("res://Levels/Level2/Level2.tscn")

var loader
var new_scene

func _ready():
	levelChangeColorRect.hide()
	loader = ResourceLoader.load_interactive("res://Levels/Level2/Level2.tscn")
	
func change():
	var err = loader.poll()
	if err == ERR_FILE_EOF:
		new_scene = loader.get_resource()
		get_tree().change_scene_to(new_scene)
		set_process(false)
	elif err == OK:
		print("Loading: ", loader.get_progress() / loader.get_progress_max())
	else:
		print("An error occurred while loading the scene.")
		set_process(false)

func _on_Play_pressed():
	change()

func _on_Quit_pressed():
	get_tree().quit()
