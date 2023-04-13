extends Node

func _ready():
	get_node("Player").get_node("Camera").far = 50
