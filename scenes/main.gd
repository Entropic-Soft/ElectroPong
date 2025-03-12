extends Node2D

var score := [0, 0] # 0: Player, 1: CPU
var PADDLE_SPEEDsingle : int = 700
const PADDLE_SPEED : int = 6700
var difficulty : String = "Easy"  # Default difficulty
var max_score : int = 11  # Default value

@onready var sfx_bf: AudioStreamPlayer2D = $sfx_bf  

var music_list = [
	"res://assets/audio/Just The Two Of Us.mp3",
	"res://assets/audio/AC_DC20Thunderstruck202).mp3",
	"res://assets/audio/椎名もた(siinamota) - Young Girl A  少女A.mp3",
	"res://assets/audio/Chess Type Beat (Slowed).mp3",
	"res://assets/Gorillaz - Feel Good Inc. (Official Video).mp3"
]

func _ready():
	if sfx_bf == null:
		print("sfx_bf node is not found!")
		return
	
	# Randomize the seed for random function
	randomize()
	# Play random music from the list
	play_random_music()

	# Load settings from the config file
	var config = ConfigFile.new()
	if config.load("user://settings.cfg") == OK:
		max_score = config.get_value("settings", "max_score", 11)
		if config.get_value("settings", "game_type", "Player") == "Computer":
			$Hud/PlayerLabel.text = config.get_value("settings", "player_name", "Player")
			$Hud/CPULabel.text = "CPU"
		else:
			$Hud/PlayerLabel.text = config.get_value("settings", "player1_name", "Player 1")
			$Hud/CPULabel.text = config.get_value("settings", "player2_name", "Player 2")

func set_difficulty(new_difficulty: String):
	difficulty = new_difficulty  # Store difficulty setting
	match difficulty:
		"Easy":
			PADDLE_SPEEDsingle = 400
		"Medium":
			PADDLE_SPEEDsingle = 700
		"Hard":
			PADDLE_SPEEDsingle = 900
		"Insane":
			PADDLE_SPEEDsingle = 1200
	
	# Update the HUD label to show the difficulty
	$Hud/difficulty.text = "Difficulty: " + difficulty

func check_game_over():
	if score[0] >= max_score or score[1] >= max_score:
		get_tree().change_scene_to_file("res://ui/game_over.tscn")

func _on_ball_timer_timeout():
	$Ball.new_ball()

func _on_score_left_body_entered(body):
	score[1] += 1
	$Hud/CPUScore.text = str(score[1])
	check_game_over() 
	$BallTimer.start()

func _on_score_right_body_entered(body):
	score[0] += 1
	$Hud/PlayerScore.text = str(score[0])
	check_game_over() 
	$BallTimer.start()

# Function to play random music from the list
func play_random_music():
	var random_music = music_list[randi() % music_list.size()]
	var music_stream = load(random_music)
	if music_stream != null:
		sfx_bf.stream = music_stream
		sfx_bf.play()
	else:
		print("Failed to load music: " + random_music)
