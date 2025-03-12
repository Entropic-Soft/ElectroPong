extends Control

@onready var sfx_click: AudioStreamPlayer = $sfx_click
@onready var spinbox: SpinBox = $VBoxContainer/HBoxContainer/SpinBox

var game_type : String = "Player"
var difficulty : String = "Easy"
var max_score : int = 11  # Default max score

func _ready() -> void:
	$VBoxContainer3.visible = false
	
	# Load settings
	var config = ConfigFile.new()
	if config.load("user://settings.cfg") == OK:
		game_type = config.get_value("settings", "game_type", "Player")
		difficulty = config.get_value("settings", "difficulty", "Easy")
		max_score = config.get_value("settings", "max_score", 11)

	# Set UI elements to match loaded values
	$VBoxContainer2/HBoxContainer/game_type.text = game_type
	spinbox.value = max_score  # Set SpinBox value
	
	# Connect signals
	$VBoxContainer2/HBoxContainer/game_type.pressed.connect(_on_game_type_pressed)
	spinbox.value_changed.connect(_on_spinbox_value_changed)

func _on_game_type_pressed() -> void:
	if game_type == "Computer":
		game_type = "Player"
		sfx_click.play()
		$VBoxContainer3.visible = false
	else:
		game_type = "Computer"
		sfx_click.play()
		$VBoxContainer3.visible = true
	$VBoxContainer2/HBoxContainer/game_type.text = game_type

func _on_easy_pressed() -> void:
	difficulty = "Easy"
	sfx_click.play()
	save_settings()

func _on_medium_pressed() -> void:
	difficulty = "Medium"
	sfx_click.play()
	save_settings()

func _on_hard_pressed() -> void:
	difficulty = "Hard"
	sfx_click.play()
	save_settings()

func _on_insane_pressed() -> void:
	difficulty = "Insane"
	sfx_click.play()
	save_settings()

func _on_spinbox_value_changed(value: float):
	sfx_click.play()
	max_score = int(value)  # Update max score when SpinBox changes

func save_settings():
	var config = ConfigFile.new()
	config.set_value("settings", "game_type", game_type)
	config.set_value("settings", "difficulty", difficulty)
	config.set_value("settings", "max_score", max_score)  # Save max score
	config.save("user://settings.cfg")
	get_tree().change_scene_to_file("res://ui/menu_main.tscn")  # Go back to menu

func _on_save__back_pressed() -> void:
	sfx_click.play()
	save_settings()  
