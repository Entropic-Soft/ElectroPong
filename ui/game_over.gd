extends Control

@onready var sfx_click: AudioStreamPlayer = $sfx_click
@onready var winner: Label = $winner
@onready var sfx_over: AudioStreamPlayer = $sfx_over

func _ready() -> void:
	sfx_over.play()
	display_winner()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):  # Enter key or controller accept
		_on_return_pressed()

func _on_return_pressed() -> void:
	sfx_click.play()
	await sfx_click.finished  # Wait for the sound to finish
	get_tree().change_scene_to_file("res://ui/menu_main.tscn")

func display_winner() -> void:
	var config = ConfigFile.new()
	if config.load("user://settings.cfg") == OK:
		var game_type = config.get_value("settings", "game_type", "Player")

		if game_type == "Computer":
			var player_score = config.get_value("settings", "player_score", 0)
			var cpu_score = config.get_value("settings", "cpu_score", 0)
			var player_name = config.get_value("settings", "player_name", "Player")

			if player_score > cpu_score:
				winner.text = player_name + " Wins!"
			else:
				winner.text = "CPU Wins!"
		else:
			var player1_score = config.get_value("settings", "player1_score", 0)
			var player2_score = config.get_value("settings", "player2_score", 0)
			var player1_name = config.get_value("settings", "player1_name", "Player 1")
			var player2_name = config.get_value("settings", "player2_name", "Player 2")

			if player1_score > player2_score:
				winner.text = player1_name + " Wins!"
			else:
				winner.text = player2_name + " Wins!"
	else:
		winner.text = "Game Over!"
