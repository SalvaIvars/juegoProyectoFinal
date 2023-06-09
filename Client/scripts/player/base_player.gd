extends Spatial
class_name BasePlayer

signal state_changed

onready var options = get_node("/root/GlobalSettings")

onready var head = get_node("head")
onready var camera = get_node("head/camera")
onready var gun = get_node("head/holder/gun")
onready var flash = gun.get_node("flash")
onready var flash_timer = gun.get_node("flash/timer")

var state = {
	dead = false,
	firing = false
}

func _ready():
	flash_timer.connect("timeout", self, "_on_flash_timeout")

func _physics_process(delta):
	pass

puppet func hit():
	get_node("sounds/impact").play()

puppet func winner_match(name):
	game.set_name(name)
	game.set_is_paused(true)
	game.add_number_of_games()
	get_tree().change_scene("res://Client/ui/menu/WinnerMenu.tscn")

puppet func fire():
	gun.get_node("sounds/fire").play()
	gun.get_node("MuzzleFlash").flash()

func _on_flash_timeout():
	flash.visible = false

puppet func update_pos_rot(pos, rot, h_rot):
	translation = pos
	rotation = rot
	head.rotation = h_rot

puppet func update_state(s, b):
	state[s] = b
	emit_signal("state_changed", s, b)
