extends Control

@onready var vbox_single = $VideoStreamPlayer/VBoxContainer
@onready var vbox_p1 = $VideoStreamPlayer/VBoxContainer2
@onready var vbox_p2 = $VideoStreamPlayer/VBoxContainer3
@onready var lineedit_single = $VideoStreamPlayer/VBoxContainer/LineEdit
@onready var lineedit_p1 = $VideoStreamPlayer/VBoxContainer2/LineEdit
@onready var lineedit_p2 = $VideoStreamPlayer/VBoxContainer3/LineEdit
@onready var enter_button = $Enter
@onready var sfx_play: AudioStreamPlayer = $sfx_play

var game_type: String = "Player"
var next_scene: String = ""  

func _ready() -> void:
	# Load game type from settings
	var config = ConfigFile.new()
	if config.load("user://settings.cfg") == OK:
		game_type = config.get_value("settings", "game_type", "Player")
	
	# Hide UI elements based on game type
	if game_type == "Computer":
		vbox_p1.visible = false
		vbox_p2.visible = false
	else:
		vbox_single.visible = false

	enter_button.grab_focus()

	sfx_play.finished.connect(_on_sfx_play_finished)

func _on_enter_pressed() -> void:
	var config = ConfigFile.new()
	
	if game_type == "Computer":
		var player_name = lineedit_single.text.strip_edges()
		if player_name.is_empty():
			player_name = "Player"  # Default name if empty
		config.set_value("settings", "player_name", player_name)
		config.set_value("settings", "cpu_name", "CPU")
		next_scene = "res://scenes/main.tscn"  # AI mode
	else:
		var player1_name = lineedit_p1.text.strip_edges()
		var player2_name = lineedit_p2.text.strip_edges()
		
		if player1_name.is_empty():
			player1_name = "Player 1"
		if player2_name.is_empty():
			player2_name = "Player 2"
		
		config.set_value("settings", "player1_name", player1_name)
		config.set_value("settings", "player2_name", player2_name)
		next_scene = "res://scenes/1v1.tscn"  # 1v1 mode

	config.save("user://settings.cfg")

	# Play the sound effect before loading the scene
	sfx_play.play()

func _on_sfx_play_finished() -> void:
	if next_scene != "":
		get_tree().change_scene_to_file(next_scene)
