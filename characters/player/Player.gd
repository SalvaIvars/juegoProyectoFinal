extends KinematicBody

var hotkeys = {
	KEY_1: 0,
	KEY_2: 1,
	KEY_3: 2,
	KEY_4: 3,
	KEY_5: 4,
}

onready var options = get_node("/root/GlobalSettings")

onready var camera = $Camera
onready var character_mover = $CharacterMover
onready var health_manager = $HealthManager
onready var weapon_manager = $Camera/WeaponManager
onready var pickup_manager = $PickupManager

var dead = false

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	character_mover.init(self)
	pickup_manager.max_player_health = health_manager.max_health
	health_manager.connect("health_changed", pickup_manager, "update_player_health")
	pickup_manager.connect("got_pickup", weapon_manager, "get_pickup")
	pickup_manager.connect("got_pickup", health_manager, "get_pickup")
	health_manager.init()
	health_manager.connect("dead", self, "kill")
	weapon_manager.init($Camera/FirePoint, [self])
	$AudioMachineGun.pitch_scale = 0.01
	var node_var = get_node_or_null("/root/Level3")
	if node_var:
		character_mover.move_accel = 4
		character_mover.max_speed = 25
	start_player()

func start_player():
	$CanvasLayer.hide()
	Input.action_press("move_forward")
	Input.action_press("attack")
	load_camera()
	yield(get_tree().create_timer(1), "timeout")
	Input.action_release("move_forward")
	Input.action_release("attack")
	yield(get_tree().create_timer(2), "timeout")
	$CanvasLayer.show()
	weapon_manager.switch_to_weapon_slot(0)
	weapon_manager.remove_machinegun()
	$AudioMachineGun.pitch_scale = 1
	self.transform.origin = Vector3(21.2, 9,36)
	rotation_degrees.y -=  options.mouse_sens * 24.0
	camera.rotation_degrees.x -=  options.mouse_sens * 154.0
	camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, -90, 90)

func load_camera():
	for i in range(0, 45, 1):
		yield(get_tree().create_timer(0.01), "timeout")
		rotation_degrees.y -=  options.mouse_sens * i
		camera.rotation_degrees.x -=  options.mouse_sens * i
		camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, -90, 90)
	for i in range(0, -40, -1):
		yield(get_tree().create_timer(0.01), "timeout")
		rotation_degrees.y -=  options.mouse_sens * i
		camera.rotation_degrees.x -=  options.mouse_sens * i
		camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, -90, 90)

func simulate_key(which_key):
  var ev = InputEvent.new()
  ev.type = InputEvent.KEY
  ev.scancode = which_key
  get_tree().input_event(ev)

func _process(_delta):
	$Camera.fov = options.fov
	if self.transform.origin.y < -25:
		kill()
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()
	if Input.is_action_just_pressed("pause"):
		get_node("PauseMenu").set_is_paused(true)
	
	if dead:
		return
	
	var move_vec = Vector3()
	if Input.is_action_pressed("move_forward"):
		move_vec += Vector3.FORWARD
	if Input.is_action_pressed("move_backwards"):
		move_vec += Vector3.BACK
	if Input.is_action_pressed("move_left"):
		move_vec += Vector3.LEFT
	if Input.is_action_pressed("move_right"):
		move_vec += Vector3.RIGHT
	character_mover.set_move_vec(move_vec)
	if Input.is_action_just_pressed("jump"):
		character_mover.jump()
	
	weapon_manager.attack(Input.is_action_just_pressed("attack"), 
		Input.is_action_pressed("attack"))

func _input(event):
	if event is InputEventMouseMotion:
		rotation_degrees.y -=  options.mouse_sens * event.relative.x
		camera.rotation_degrees.x -=  options.mouse_sens * event.relative.y
		camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, -90, 90)
	if event is InputEventKey and event.pressed:
		if event.scancode in hotkeys:
			weapon_manager.switch_to_weapon_slot(hotkeys[event.scancode])
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == BUTTON_WHEEL_DOWN:
			weapon_manager.switch_to_next_weapon()
		if event.button_index == BUTTON_WHEEL_UP:
			weapon_manager.switch_to_last_weapon()

func hurt(damage, dir):
	$AudioStreamPlayer2D.play()
	health_manager.hurt(damage, dir)

func heal(amount):
	health_manager.heal(amount)

func kill():
	$CanvasLayer.hide()
	dead = true
	character_mover.freeze()
	get_node("DeathMenu").set_is_paused(true)
