extends Node2D

# TO DO
# Make a proper grid with walls
# Make snake be able to grow and collide with itself
# Input buffer?

# VARIABLES

# Exporting snake cell variable to inspector for ease of use
@export var snake_cell_scene: PackedScene
@export var apple_regular_scene: PackedScene
@export var grid_width: int = 12
@export var grid_height: int = 8

# General game variables
var score: int
var game_started: bool = false
var grid_size: int = 20
var cell_size: int = 50

# Snake data
var last_step_data: Array
var current_step_data: Array
var snake: Array

# Snake movement
var start_pos = Vector2(0,0)
const input_directions := {
	"move_up": Vector2.UP,
	"move_down": Vector2.DOWN,
	"move_left": Vector2.LEFT,
	"move_right": Vector2.RIGHT,
}
var move_dir: Vector2
var can_move: bool

# Built in function to run on start
func _ready():
	new_game()

# Resets score, move_dir, can_move, and makes the snake
func new_game():
	score = 0
	$UI.get_node("Score").text = "Score: " + str(score)
	move_dir = Vector2.UP
	can_move = true
	make_snake()
	add_apple()

# Clears snake data and makes a new snake
func make_snake():
	last_step_data.clear()
	current_step_data.clear()
	snake.clear()
	
	for i in range(3):
		add_cell(start_pos + Vector2(0, i))

# Adds a cell to the snake
func add_cell(pos):
	current_step_data.append(pos)
	# Adding new snake cell object to the array
	var snake_cell = snake_cell_scene.instantiate()
	snake_cell.position = (pos * cell_size) + Vector2(0, cell_size)
	add_child(snake_cell)
	snake.append(snake_cell)
	
func add_apple():
	var apple = apple_regular_scene.instantiate()
	apple.position = (get_random_position() * cell_size) + Vector2(0, cell_size)
	add_child(apple)

# Built in function to process stuff continually
func _process(_delta):
	handle_input()

# Handles user input
func handle_input() -> void:
	if not can_move:
		return

	for action in input_directions:
		# Goes through "move_up", "move_down" etc and checks if its pressed
		var new_dir: Vector2 = input_directions[action]
		if Input.is_action_just_pressed(action) and new_dir != -move_dir:
			move_dir = new_dir
			can_move = false
			if not game_started:
				start_game()

# Moves the snake
func move_snake() -> void:
	# Copies the current step data into last step and moves the head data
	last_step_data = current_step_data.duplicate()
	current_step_data[0] += move_dir

	# Moves all of the data to be one square ahead
	for i in range(1, current_step_data.size()):
		current_step_data[i] = last_step_data[i - 1]

	# Moves the actual snake cell objects one square ahead
	for i in snake.size():
		snake[i].position = (current_step_data[i] * cell_size) + Vector2(0, cell_size)

# If the game starts then start the timer and other stuff
func start_game():
	game_started = true
	$Timer.start()

# Connected to timer node so every time it hits the set time it calls this
func _on_timer_timeout() -> void:
	can_move = true
	move_snake()

func get_random_position() -> Vector2:
	var random_x = randi_range(0, grid_width - 1)
	var random_y = randi_range(0, grid_height -1)
	return Vector2(random_x, random_y)
