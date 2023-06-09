extends Area


var bodies_to_exclude = ["BirdMonster", "ReptileMonster", "WizardMinion", "Wizard"]
export var damage = 10

func set_damage(_damage: int):
	damage = _damage

func set_bodies_to_exclude(_bodies_to_exclude: Array):
	bodies_to_exclude = _bodies_to_exclude

func fire():
	for body in get_overlapping_bodies():
		if body.has_method("hurt") and !body.name.begins_with("ReptileMonster") and !body.name.begins_with("WizardMinion") and !body.name.begins_with("BirdMonster"):
			body.hurt(damage, global_transform.origin.direction_to(body.global_transform.origin))

