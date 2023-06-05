extends Spatial

var end = true
var nodo = null

func _ready():
	yield(get_tree().create_timer(3), "timeout")
	$LevelAnimation.hide()

func _process(_delta):
	nodo = get_node_or_null("/root/Level3/Navigation/Wizard")
	if(nodo == null and end):
		end_level()

func end_level():
	end = false
	yield(get_tree().create_timer(3), "timeout")
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().change_scene("res://ui/menu/FinishMenu.tscn")
