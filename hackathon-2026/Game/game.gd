extends Node2D

# TO DO
# Make a proper grid with walls
# Make snake be able to grow and collide with itself
# Input buffer?

# Nathan - Cleaning up snake's code and moving it to separate snake_script

# VARIABLES

# Exporting snake cell variable to inspector for ease of use
@export var snake_cell_scene: PackedScene

# General game variables
var score: int
var game_started: bool = false
@export var grid_size: int = 20
@export var cell_size: int = 50

#Snake reference
@onready var snake = $Snake

# Built in function to run on start
func _ready():
	new_game()

# Resets score, move_dir, can_move, and makes the snake
func new_game():
	score = 0
	$UI.get_node("Score").text = "Score: " + str(score)
	make_snake()

# Clears snake data and makes a new snake
func make_snake():
	snake.Initialize()

# Adds a cell to the snake
func add_cell(pos):
	# Adding new snake cell object to the array
	var snake_cell = snake_cell_scene.instantiate()
	snake_cell.position = (pos * cell_size) + Vector2(0, cell_size)
	add_child(snake_cell)
	snake.append(snake_cell)

# Built in function to process stuff continually
func _process(_delta):
	pass

# If the game starts then start the timer and other stuff
func start_game():
	game_started = true
	$Timer.start()

# Connected to timer node so every time it hits the set time it calls this
func _on_timer_timeout() -> void:
	snake.move_snake()
