extends Spatial

var jefe = null

func _ready():
	yield(get_tree().create_timer(3), "timeout")
	$LevelAnimation.hide()

func _process(delta):
	jefe = get_node_or_null("/root/NivelFinal/Navigation/Wizard")
	if jefe == null:
		end_game()

func end_game():
	yield(get_tree().create_timer(1), "timeout")
	get_tree().change_scene("res://ui/menu/FinishMenu.tscn")
