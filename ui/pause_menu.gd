extends Control

@onready var pause_menu = $Panel  
@onready var resume_button = $Panel/VBoxContainer/Resume  
@onready var exit_button = $Panel/VBoxContainer/Exit  

var is_paused := false

func _ready() -> void:
	pause_menu.visible = false  # Hide menu at start

	resume_button.pressed.connect(_on_resume_pressed)
	exit_button.pressed.connect(_on_exit_pressed)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		toggle_pause()

func toggle_pause():
	is_paused = !is_paused
	get_tree().paused = is_paused  # Pause/unpause game logic
	pause_menu.visible = is_paused  # Show/hide UI

	if is_paused:
		print("Pause menu opened")
		resume_button.grab_focus()  # Auto-focus Resume button

func _on_resume_pressed() -> void:
	print("Resume button clicked")  # Debug message
	toggle_pause()  # Unpause when clicking Resume

func _on_exit_pressed() -> void:
	print("Exit button clicked")  # Debug message
	get_tree().paused = false  # Unpause before exiting
	get_tree().change_scene_to_file("res://ui/menu_main.tscn")  # Back to main menu
