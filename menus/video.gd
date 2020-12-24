extends Panel

onready var fullscreen_button = $MarginContainer/VBoxContainer/Fullscreen
onready var shadow_slider = $MarginContainer/VBoxContainer/QualitySliders/ShadowQuality/HSlider
onready var render_scale_slider = $MarginContainer/VBoxContainer/QualitySliders/RenderScale/HSlider

func _ready():
	fullscreen_button.pressed = Settings.fullscreen
	shadow_slider.value = Settings.shadow_quality
	render_scale_slider.value = Settings.render_scale
	$MarginContainer/VBoxContainer/QualitySliders/RenderIndicator.text = "%s" % [render_scale_slider.value]
	$MarginContainer/VBoxContainer/QualitySliders/ShadowIndicator.text = "%s" % [shadow_slider.value]

func _on_Back_pressed():
	get_tree().change_scene("res://menus/settings.tscn")

func _on_Fullscreen_toggled(button_pressed):
	Settings.set_fullscreen(button_pressed)
	pass # Replace with function body.

func _on_RenderScale_value_changed(value):
	Settings.render_scale = value
	$MarginContainer/VBoxContainer/QualitySliders/RenderIndicator.text = "%s" % [render_scale_slider.value]
	#$MarginContainer/VBoxContainer/QualitySliders/RenderIndicator.text = "%s" [render_scale_slider.value]

func _on_ShadowQuality_value_changed(value):
	Settings.shadow_quality = value
	$MarginContainer/VBoxContainer/QualitySliders/ShadowIndicator.text = "%s" % [shadow_slider.value]

func _on_DebugTrails_toggled(button_pressed):
	GameInfo.start_with_debug_trails = button_pressed
