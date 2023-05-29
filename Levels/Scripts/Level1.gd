extends Spatial

var loader
var new_scene
var change = true
var player

func _process(delta):
	player = get_tree().get_nodes_in_group("player")[0]
	var position = player.global_transform.origin

	if position.x >= 300 and change:
		change = false
		start_loading()


func start_loading():
	change()
	
func change():
	get_tree().change_scene("res://Levels/level3/Level3.tscn")

func _ready():
	yield(get_tree().create_timer(3), "timeout")
	$LevelAnimation.hide()
