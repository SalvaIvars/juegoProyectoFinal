extends Popup

onready var options = get_node("/root/GlobalSettings")

# Audio Settings
onready var master_slider = $MarginContainer3/GameplaySettings/Volume/Volume
onready var master_amount = $MarginContainer3/GameplaySettings/Volume/Volume2

# Gameplay Settings
onready var fov_amount = $MarginContainer3/GameplaySettings/FovOption/FovAmount
onready var fov_slider = $MarginContainer3/GameplaySettings/FovOption/FovSlider
onready var mouse_sens_amount = $MarginContainer3/GameplaySettings/MouseSensOption/MouseSensAmount
onready var mouse_slider = $MarginContainer3/GameplaySettings/MouseSensOption/MouseSlider

func _ready():
	master_slider.value = options.volume
	fov_slider.value = options.fov
	mouse_slider.value = options.mouse_sens

func _on_MasterSlider_value_changed(value):
	GlobalSettings.update_master_vol(value)
	master_amount.text = str(value)
func _on_FovSlider_value_changed(value):
	GlobalSettings.update_fov(value)
	fov_amount.text = str(value)
	

func _on_MouseSlider_value_changed(value):
	GlobalSettings.update_mouse_sens(value)
	mouse_sens_amount.text = str(value)
	
func _on_Button_pressed():
	self.visible = false
