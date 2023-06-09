extends Node

signal fps_displayed(value)
signal bloom_toggled(value)
signal brightness_updated(value)
signal fov_updated(value)
signal mouse_sens_updated(value)

var mouse_sens = 0.5
var fov = 70
var volume = 0.5

func toggle_fullscreen(toggle):
	OS.window_fullscreen = toggle
	
func toggle_vsync(toggle):
	OS.vsync_enabled = toggle

func update_master_vol(vol):
	AudioServer.set_bus_volume_db(0, vol)

func update_music_vol(vol):
	AudioServer.set_bus_volume_db(1, vol)

func update_fov(value):
	fov =  value

func update_mouse_sens(value):
	mouse_sens =  value

