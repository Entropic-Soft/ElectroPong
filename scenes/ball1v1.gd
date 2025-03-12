extends CharacterBody2D

var win_size: Vector2
const START_SPEED: int = 700
const ACCEL: int = 400
const MAX_SPEED: int = 1800  # Prevents the game from becoming unplayable
const MIN_Y_VECTOR: float = 0.2  # Ensures more angled shots
const MAX_Y_VECTOR: float = 0.8  # Allows some randomness
@onready var sfx_hitpaddle: AudioStreamPlayer2D = $"../sfx_hitpaddle"
@onready var ball_sprite = $ColorRect  # Ensure it gets the reference

var speed: int
var dir: Vector2
var time_elapsed: float = 0.0  # Used for gradual acceleration

func _ready():
	win_size = get_viewport_rect().size

func new_ball():
	# Randomize start position and direction
	position = Vector2(win_size.x / 2, randi_range(200, win_size.y - 200))
	speed = START_SPEED
	dir = random_direction()

func _physics_process(delta):
	time_elapsed += delta
	
	# Gradual acceleration over time (prevents boring slow starts)
	if time_elapsed > 5.0:  # Every 5 seconds, increase speed slightly
		speed = min(speed + 50, MAX_SPEED)  # Prevents exceeding MAX_SPEED
		time_elapsed = 0.0  # Reset timer

	var collision = move_and_collide(dir * speed * delta)
	if collision:
		var collider = collision.get_collider()

		# If ball hits paddle
		if collider == $Player1 or collider == $Player2:
			speed = min(speed + ACCEL, MAX_SPEED)  # Controlled speed increase
			dir = new_direction(collider)
			play_paddle_sfx()
		# If ball hits wall
		else:
			dir = dir.bounce(collision.get_normal())
			play_paddle_sfx()

func spawn_trail():
	if not ball_sprite:  # Prevents null errors
		return

	var ghost = Sprite2D.new()
	ghost.texture = ball_sprite.texture  
	ghost.global_position = global_position
	ghost.modulate.a = 0.8  # Semi-transparent

	get_parent().add_child(ghost)

	# Tween to fade out and delete ghost
	var tween = get_tree().create_tween()
	tween.tween_property(ghost, "modulate:a", 0, 0.5)
	tween.tween_callback(ghost.queue_free)

func random_direction():
	var new_dir := Vector2()
	new_dir.x = [-1, 1].pick_random()  # Random left or right
	new_dir.y = randf_range(-MAX_Y_VECTOR, MAX_Y_VECTOR)

	# Prevent near-horizontal shots
	if abs(new_dir.y) < MIN_Y_VECTOR:
		new_dir.y = sign(new_dir.y) * MIN_Y_VECTOR

	return new_dir.normalized()

func _process(delta):
	spawn_trail()

func new_direction(collider):
	var ball_y = position.y
	var pad_y = collider.position.y
	var dist = ball_y - pad_y
	var new_dir := Vector2()

	# Flip horizontal direction
	new_dir.x = -sign(dir.x)

	# Adjust vertical direction based on collision position
	new_dir.y = clamp((dist / (collider.pHeight / 2)) * MAX_Y_VECTOR, -MAX_Y_VECTOR, MAX_Y_VECTOR)

	# Add slight randomness to prevent predictable shots
	new_dir.y += randf_range(-0.1, 0.1)

	return new_dir.normalized()

func play_paddle_sfx():
	# Apply slight pitch variation for more natural sound
	sfx_hitpaddle.pitch_scale = randf_range(0.8, 1.2)
	sfx_hitpaddle.play()
