extends KinematicBody

onready var character_mover = $CharacterMover
onready var health_mananger = $HealthManager

onready var anim_player = $AnimationPlayer
onready var nav : Navigation = get_parent()
onready var aimer = $AimAtObject
onready var graphics = $Graphics

enum STATES {IDLE, CHASE, ATTACK, DEAD}
var cur_state = STATES.IDLE

var player = null
var path = []

export var sight_angle = 45.0
export var turn_speed = 360.0

export var attack_angle = 5.0
export var attack_range = 2.0
export var attack_rate = 0.5
export var invoke_rate = 10
export var attack_anim_speed_mod = 0.5
var attack_timer : Timer
var invoke_timer : Timer
var can_attack = true
var can_invoke = true

onready var wizard_minion = preload("res://characters/enemies/WizardMinion.tscn")

signal attack

func _ready():
	attack_timer = Timer.new()
	attack_timer.wait_time = attack_rate
	attack_timer.connect("timeout", self, "finish_attack")
	attack_timer.one_shot = true
	add_child(attack_timer)
	
	invoke_timer = Timer.new()
	invoke_timer.wait_time = invoke_rate
	invoke_timer.connect("timeout", self, "invoke_minion")
	invoke_timer.one_shot = false
	add_child(invoke_timer)
	invoke_timer.start()
	
	player = get_tree().get_nodes_in_group("player")[0]
	var bone_attachments = $Graphics/Armature/Skeleton/HitBox
	if bone_attachments is HitBox:
		bone_attachments.connect("hurt", self, "hurt")
	
	health_mananger.connect("dead", self, "set_state_dead")
	character_mover.init(self)
	set_state_idle()

func _process(delta):
	match cur_state:
		STATES.IDLE:
			process_state_idle(delta)
		STATES.CHASE:
			process_state_chase(delta)
		STATES.ATTACK:
			process_state_attack(delta)
		STATES.DEAD:
			process_state_dead(delta)

func set_state_idle():
	cur_state = STATES.IDLE
	anim_player.play("Idle")

func set_state_chase():
	cur_state = STATES.CHASE
	anim_player.play("Idle")

func set_state_attack():
	cur_state = STATES.ATTACK

func set_state_dead():
	cur_state = STATES.DEAD
	character_mover.freeze()
	$CollisionShape.disabled = true
	graphics.hide()
	self.queue_free()

func process_state_idle(delta):
	if can_see_player():
		set_state_chase()

func process_state_chase(delta):
	if within_dis_of_player(attack_range) and has_los_player():
		set_state_attack()
	var player_pos = player.global_transform.origin
	var our_pos = global_transform.origin
	path = nav.get_simple_path(our_pos, player_pos)
	var goal_pos = player_pos
	if path.size() > 1:
		goal_pos = path[1]
	var dir = goal_pos - our_pos
	dir.y = 0
	character_mover.set_move_vec(dir)
	face_dir(dir, delta)

func process_state_attack(delta):
	character_mover.set_move_vec(Vector3.ZERO)
	if can_attack:
		if !within_dis_of_player(attack_range) or !can_see_player():
			set_state_chase()
		elif !player_within_angle(attack_angle):
			face_dir(global_transform.origin.direction_to(player.global_transform.origin), delta)
		else:
			start_attack()

func process_state_dead(delta):
	pass

func hurt(damage: int, dir: Vector3):
	if cur_state == STATES.IDLE:
		set_state_chase()
	health_mananger.hurt(damage, dir)

func start_attack():
	can_attack = false
	anim_player.play("ArmatureAction_001", -1, attack_anim_speed_mod)
	attack_timer.start()
	aimer.aim_at_pos(player.global_transform.origin + Vector3.UP)

func emit_attack_signal():
	emit_signal("attack")

func finish_attack(): 
	can_attack = true
	
func invoke_minion():
	var minion = wizard_minion.instance()
	var add_distance = Vector3(1,0,0)
	minion.transform.origin = self.global_transform.origin + add_distance
	var prueba = get_parent().get_parent().get_node("Navigation").add_child(minion)
	

func can_see_player():
	return player_within_angle(sight_angle) and has_los_player()

func player_within_angle(angle: float):
	var dir_to_player = global_transform.origin.direction_to(player.global_transform.origin)
	var forwards = global_transform.basis.z
	return rad2deg(forwards.angle_to(dir_to_player)) < angle 

func has_los_player():
	var our_pos = global_transform.origin + Vector3.UP
	var player_pos = player.global_transform.origin + Vector3.UP
	var prueba_player_pos = our_pos 
	var space_state = get_world().get_direct_space_state()
	var result = space_state.intersect_ray(our_pos, player_pos, [], 1)
	if result:
		return false
	return true

func face_dir(dir: Vector3, delta):
	var angle_diff = global_transform.basis.z.angle_to(dir)
	var turn_right = sign(global_transform.basis.x.dot(dir))
	if abs(angle_diff) < deg2rad(turn_speed) * delta:
		rotation.y = atan2(dir.x, dir.z)
	else:
		rotation.y += deg2rad(turn_speed) * delta * turn_right

func alert(check_los=true):
	if cur_state != STATES.IDLE:
		return
	if check_los and !has_los_player():
		return
	set_state_chase()

func within_dis_of_player(dis: float):
	return global_transform.origin.distance_to(player.global_transform.origin) < attack_range
