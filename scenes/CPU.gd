extends StaticBody2D

var ball_pos : Vector2
var dist : int
var move_by : int
var win_height : int
var pHeight : int
var top_limit : int
var bottom_limit : int

var difficulty = "Easy"
# Called when the node enters the scene tree for the first time.
func _ready():
	win_height = get_viewport_rect().size.y
	pHeight = $ColorRect.get_size().y

	top_limit = 100 
	bottom_limit = win_height - 100  
	var config = ConfigFile.new()
	if config.load("user://settings.cfg") == OK:
		difficulty = config.get_value("settings", "difficulty", "Easy")

	# Get reference to main scene and set difficulty
	var main_scene = get_parent()  # Make sure the CPU node is a child of main.gd
	if main_scene.has_method("set_difficulty"):
		main_scene.set_difficulty(difficulty)  

	# Adjust AI behavior based on difficulty
	match difficulty:
		"Easy":
			get_parent().PADDLE_SPEEDsingle = 400
		"Medium":
			get_parent().PADDLE_SPEEDsingle = 700
		"Hard":
			get_parent().PADDLE_SPEEDsingle = 900
		"Insane":
			get_parent().PADDLE_SPEEDsingle = 1200


func _process(delta):

	
	ball_pos = $"../Ball".position
	dist = position.y - ball_pos.y
	
	var mistake_chance = randf()
	if difficulty == "Easy" and mistake_chance < 0.3:
		return  # AI doesn't move sometimes
	elif difficulty == "Medium" and mistake_chance < 0.1:
		return  # AI delays movement slightly
	
	# Move paddle toward the ball
	if abs(dist) > get_parent().PADDLE_SPEEDsingle * delta:
		move_by = get_parent().PADDLE_SPEEDsingle * delta * (dist / abs(dist))
	else:
		move_by = dist

	position.y -= move_by
	position.y = clamp(position.y, 85 + pHeight / 2, 630 - pHeight / 2)
