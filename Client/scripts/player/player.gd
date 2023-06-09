extends BasePlayer
class_name Player

onready var name_label = get_node("Name")
onready var name_label2 = $Name
var option1 = 0
var option2 = 0

var score

func _ready():
	var rng = RandomNumberGenerator.new()
	connect("state_changed", self, "_on_state_changed")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	rng.randomize()
	option1 = int(rng.randi_range(1,5))
	option2 = int(rng.randi_range(1,5))
	while option2 == option1:
		option2 = rng.randf_range(1,5)
	print(option1)
	print(option2)
		
func _set_player_name(value):
	$Name.text = str(value)
	rpc_unreliable_id(1, "update_player_name", str(value))

func _physics_process(delta):
	$head/camera.fov = options.fov
	process_input(delta)

func _on_state_changed(s, b):
	match s:
		"dead":
			gun.visible = !state[s]
				#game.main_scene.display_message("You are dead! Respawning...")

puppet func update_score(value):
	score = value
	change_mode(value)
	get_node("hud/score").text = "Score: " + str(score)

func change_mode(value):
	if value == option1:
		back_to_normal()
		change_inversion()
	if value == option2:
		back_to_normal()
		change_movement()
	if value != option1 and value != option2:
		back_to_normal()

func back_to_normal():
	game.back_to_normal()

func change_inversion():
	game.change_inversion()

func change_movement():
	game.change_movement()
	
puppet func update_ammo(value):
	get_node("hud/ammo").text = "Ammo: " + str(value)

puppet func update_health(value):
	get_node("hud/health").text = "Health: " + str(value)

func process_input(delta):
	# Input
	if(game.movement_inverted):
		if Input.is_action_pressed("move_forward"):
			rpc_unreliable_id(1, "execute_command", "move_backward", true)
		else:
			rpc_unreliable_id(1, "execute_command", "move_backward", false)
		if Input.is_action_pressed("move_backward"):
			rpc_unreliable_id(1, "execute_command", "move_forward", true)
		else:
			rpc_unreliable_id(1, "execute_command", "move_forward", false)
		if Input.is_action_pressed("move_left"):
			rpc_unreliable_id(1, "execute_command", "move_right", true)
		else:
			rpc_unreliable_id(1, "execute_command", "move_right", false)
		if Input.is_action_pressed("move_right"):
			rpc_unreliable_id(1, "execute_command", "move_left", true)
		else:
			rpc_unreliable_id(1, "execute_command", "move_left", false)
		if Input.is_action_pressed("move_jump"):
			rpc_unreliable_id(1, "execute_command", "move_jump", true)
		else:
			rpc_unreliable_id(1, "execute_command", "move_jump", false)
		if Input.is_action_pressed("primary_fire"):
			rpc_unreliable_id(1, "execute_command", "primary_fire", true)
		else:
			rpc_unreliable_id(1, "execute_command", "primary_fire", false)
	else:
		if Input.is_action_pressed("move_forward"):
			rpc_unreliable_id(1, "execute_command", "move_forward", true)
		else:
			rpc_unreliable_id(1, "execute_command", "move_forward", false)
		if Input.is_action_pressed("move_backward"):
			rpc_unreliable_id(1, "execute_command", "move_backward", true)
		else:
			rpc_unreliable_id(1, "execute_command", "move_backward", false)
		if Input.is_action_pressed("move_left"):
			rpc_unreliable_id(1, "execute_command", "move_left", true)
		else:
			rpc_unreliable_id(1, "execute_command", "move_left", false)
		if Input.is_action_pressed("move_right"):
			rpc_unreliable_id(1, "execute_command", "move_right", true)
		else:
			rpc_unreliable_id(1, "execute_command", "move_right", false)
		if Input.is_action_pressed("move_jump"):
			rpc_unreliable_id(1, "execute_command", "move_jump", true)
		else:
			rpc_unreliable_id(1, "execute_command", "move_jump", false)
		if Input.is_action_pressed("primary_fire"):
			rpc_unreliable_id(1, "execute_command", "primary_fire", true)
		else:
			rpc_unreliable_id(1, "execute_command", "primary_fire", false)
	
	# Capturing/freeing the cursor
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rpc_unreliable_id(1, "update_rotation", event.relative.x * options.mouse_sens * game.INVERSION, event.relative.y * options.mouse_sens * game.INVERSION)
