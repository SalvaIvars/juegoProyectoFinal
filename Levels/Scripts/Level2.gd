extends Spatial

var end = true
var nodo = null

func _ready():
	OS.window_fullscreen = true
	yield(get_tree().create_timer(3), "timeout")
	$LevelAnimation.hide()

func end_level():
	end = false
	yield(get_tree().create_timer(3), "timeout")
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().change_scene("res://ui/menu/FinishMenu.tscn")

func change_label():
	var node = get_node_or_null("/root/Level3/Player")
	if node != null:
		node.hide_layer()
	$LevelAnimation3.show()
	yield(get_tree().create_timer(0.5), "timeout")
	start_loading()

func start_loading():
	change()
	
func change():
	get_tree().change_scene("res://Levels/Prueba/PRUEBAfinal.tscn")
