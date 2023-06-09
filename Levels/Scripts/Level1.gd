extends Spatial

var loader
var new_scene
var change_var = true
var change_label_var = true
var player

func _process(_delta):
	player = get_tree().get_nodes_in_group("player")[0]
	var position = player.global_transform.origin
	
	if position.x >= 590 and change_label_var:
		change_label_var = false
		change_label()
	

func change_label():
	var node = get_node_or_null("/root/Level5/Player")
	if node != null:
		node.hide_layer()
	$LevelAnimation2.show()
	yield(get_tree().create_timer(0.3), "timeout")
	start_loading()

func start_loading():
	change()
	
func change():
	get_tree().change_scene("res://Levels/level3/Level3_v2.tscn")

func _ready():
	yield(get_tree().create_timer(3), "timeout")
	$LevelAnimation.hide()
