extends Spatial

var loader
var new_scene
var change = true
var change_label = true
var player

func _process(delta):
	player = get_tree().get_nodes_in_group("player")[0]
	var position = player.global_transform.origin
	
	if position.x >= 390 and change_label:
		change_label = false
		change_label()
	

func change_label():
	$LevelAnimation2.show()
	yield(get_tree().create_timer(0.5), "timeout")
	start_loading()

func start_loading():
	change()
	
func change():
	get_tree().change_scene("res://Levels/level3/Level3_v2.tscn")

func _ready():
	yield(get_tree().create_timer(3), "timeout")
	$LevelAnimation.hide()
