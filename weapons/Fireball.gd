extends KinematicBody

var speed = 20
var impact_damage = 20
var exploded = false
var bodies_to_exclude = []

func _ready():
	hide()

func set_bodies_to_exclude(_bodies_to_exclude: Array):
	bodies_to_exclude = _bodies_to_exclude

func _physics_process(delta):
	var collision : KinematicCollision = move_and_collide(
		-global_transform.basis.z * speed * delta)
	if collision:
		var collider = collision.collider
		if !collider.name in bodies_to_exclude and !collider.name.begins_with("ReptileMonster") and !collider.name.begins_with("BirdMonster"):	
			if collider.has_method("hurt"):
				collider.hurt(impact_damage, -global_transform.basis.z)
		$SmokeParticles.emitting = true
		speed = 0
		$Graphics.hide()
		$CollisionShape.disabled = true
