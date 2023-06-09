extends BasePlayer
class_name Puppet

func _ready():
	connect("state_changed", self, "_on_state_changed")

func _set_player_name(value):
	$Name.text = str(value)
	$Name2.text = str(value)
	rpc_unreliable_id(1, "update_player_name", str(value))

func _on_state_changed(s, b):
	match s:
		"dead":
			visible = !state[s]
