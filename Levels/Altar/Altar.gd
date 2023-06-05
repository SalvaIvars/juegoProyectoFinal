extends Area

onready var label = $Label3D

func _ready():
	connect("body_entered", self, "_on_Area_body_entered")

func _on_Area_body_entered(body:Node):
	if body.name == "Player":
		label.show()
		change_level()

func change_level():
	var level = get_node_or_null("/root/Level5")
	level.change_label()
