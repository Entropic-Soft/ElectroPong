extends Control

var tween : Tween
@onready var sfx_play: AudioStreamPlayer = $sfx_play
@onready var sfx_click: AudioStreamPlayer = $sfx_click  # Add reference to the sfx_click sound effect

func _ready() -> void:
	# Connect button signals
	$VBoxContainer/play.pressed.connect(_on_play_pressed)
	$VBoxContainer/game_options.pressed.connect(_on_game_options_pressed)
	$VBoxContainer/quit.pressed.connect(_on_quit_pressed)
	# Create a Tween instance using get_tree().create_tween() (Godot 4)
	tween = get_tree().create_tween()

	# Grab the focus of the 'play' button
	$VBoxContainer/play.grab_focus()

	# Optional: Animate buttons on start (to give feedback)
	animate_button_scale($VBoxContainer/play)

	# Connect the 'finished' signal for sfx_click
	sfx_click.finished.connect(_on_sfx_click_finished)

	# Connect the 'finished' signal from the sfx_play sound for the play button
	sfx_play.finished.connect(_on_sfx_play_finished)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_play_pressed() -> void:
	animate_button_scale($VBoxContainer/play)
	sfx_play.play() 

# This method will be called when the 'Play' button's sound effect finishes
func _on_sfx_play_finished() -> void:
	# Load settings to check game type
	var config = ConfigFile.new()
	if config.load("user://settings.cfg") == OK:
		var game_type = config.get_value("settings", "game_type", "Player")

		# Load the correct scene based on the game type
		if game_type == "Computer":
			get_tree().change_scene_to_file("res://ui/name_input.tscn")  # AI mode
		else:
			get_tree().change_scene_to_file("res://ui/name_input.tscn")  # 1v1 mode
	else:
		#default mode
		get_tree().change_scene_to_file("res://ui/name_input.tscn")

# Game options button pressed handler
func _on_game_options_pressed() -> void:
	animate_button_scale($VBoxContainer/game_options)
	sfx_click.play() 
	sfx_click.finished.connect(_on_sfx_click_finished)

	_on_sfx_click_finished()

# Quit button pressed handler
func _on_quit_pressed() -> void:
	animate_button_scale($VBoxContainer/quit)
	sfx_click.play()  
	sfx_click.finished.connect(_on_sfx_click_finished)

	# Action after sound finishes
	_on_sfx_click_finished()

# This method will be called when any button's sfx_click sound finishes
func _on_sfx_click_finished() -> void:
	if $VBoxContainer/game_options.has_focus():
		print("Game Options button pressed")
		get_tree().change_scene_to_file("res://ui/game_options.tscn")
	elif $VBoxContainer/quit.has_focus():
		print("Quit button pressed")
		get_tree().quit()

func animate_button_scale(button : Button) -> void:
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.set_ease(Tween.EASE_OUT)

	tween.tween_property(button, "rect_scale", Vector2(1.2, 1.2), 0.1)

	tween.set_trans(Tween.TRANS_LINEAR)  # Same transition for scale back
	tween.set_ease(Tween.EASE_IN)  # Different ease for scale back
	tween.tween_property(button, "rect_scale", Vector2(1, 1), 0.1)
