extends Node

const PORT = 272

var client : NetworkedMultiplayerENet
var my_id : int = -1
var me_created : bool = false

onready var message = $ui/CenterContainer/VBoxContainer/message
onready var world = $world
onready var text_enter = $ui/CenterContainer/VBoxContainer/line_edit

onready var player_scn = preload("res://Client/scenes/player/player.tscn")
onready var puppet_scn = preload("res://Client/scenes/player/puppet.tscn")

func _ready():
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	get_tree().connect("connected_to_server", self, "_on_connected_to_server")
	get_tree().connect("connection_failed", self, "_on_connection_failed")
	get_tree().connect("server_disconnected", self, "_on_server_disconnected")
	
	create_map()
	client = NetworkedMultiplayerENet.new()

func _on_connection_failed():
	display_message("Connection failed!")
	get_tree().set_network_peer(null)

func _on_connected_to_server():
	if text_enter.text.length() != 0:
		create_map()
		display_message("Connecting...")
		my_id = get_tree().get_network_unique_id()
		display_message("Connection established. Your id is " + str(my_id))
		
		# Player
		var player = player_scn.instance()
		player.set_name(str(my_id))
		world.get_node("players").add_child(player)
		player.get_node("head/camera").current = true
		update_player_information(my_id, str(text_enter.text))
		me_created = true

func update_player_information(id, name):
	rpc_unreliable_id(1, "update_player_information", id, name)

remote func obtain_players_information(dictionary):
	var dict_array = dictionary
	for i in dict_array.keys():
		var player = world.get_node("players").get_children()
		for p in player:
			if p.name == str(i):
				p._set_player_name(dictionary[i].name)

func _on_server_disconnected():
	display_message("Server disconnected.")

func _player_connected(id):
	if text_enter.text.length() != 0:
		display_message("Connecting...")
		if me_created:
			var player = puppet_scn.instance()
			player.set_name(str(id))
			player._set_player_name(text_enter.text)
			world.get_node("players").add_child(player)

func _player_disconnected(id):
	for n in world.get_node("players").get_children():
		if int(n.name) == id:
			world.get_node("players").remove_child(n)
			n.queue_free()

func _on_connect_pressed():
	if text_enter.text.length() != 0:
		$ui/CenterContainer/VBoxContainer/button.visible = false
		text_enter.visible = false
		display_message("Connecting...")
		var ip = "localhost"
		if !ip.is_valid_ip_address():
			display_message("Connecting...")
		client.create_client(ip, PORT)
		get_tree().set_network_peer(client)

func create_map():
	if text_enter.text.length() != 0:
		display_message("Connecting...")
		# Map
		var map = load("res://Client/mapa2.tscn").instance()
		world.add_child(map)

func display_message(text : String):
	message.visible = true
	message.text = text
	$ColorRect.hide()
	$ui.hide()
	yield(get_tree().create_timer(5), "timeout")
	message.visible = false
	message.text = ""

func _on_button2_pressed():
	get_tree().change_scene("res://ui/menu/MainMenu.tscn")
