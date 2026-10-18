extends Node2D

# TO DO
# Input buffer?

# Nathan - Cleaning up snake's code and moving it to separate snake_script

# VARIABLES

# Exporting snake cell variable to inspector for ease of use
@export var apple_regular_scene: PackedScene
@export var grid_width: int = 16
@export var grid_height: int = 10

# General game variables
var score: int
var game_started: bool = false
@export var cell_size: int = 50
@export var top_ui_height: int = 40

#Snake reference
@onready var snake = $Snake

# End menu reference
@onready var game_over_menu: Control = $GameOverMenu
@onready var pause_menu: Control = $PauseMenu

# Built in function to run on start
func _ready():
	new_game()

# Resets score, move_dir, can_move, and makes the snake
func new_game():
	get_tree().paused = false
	game_over_menu.hide()
	score = 0
	$UI.get_node("Score").text = "Score: " + str(score)
	make_snake()
	add_regular_apple()
	start_game()

# Clears snake data and makes a new snake
func make_snake():
	snake.InitializeSnake()
	
func add_regular_apple():
	var apple = apple_regular_scene.instantiate()
	
	var flag = false #loops until it finds a position thats not inside the snake
	while (!flag):
		flag = true
		apple.position = (get_random_position() * cell_size) + Vector2(0, top_ui_height)
		for cell in snake.snake_cells:
			if apple.position == cell.position:
				flag = false
				
	apple.eaten_regular.connect(_on_apple_eaten_regular)
	add_child.call_deferred(apple)

func _on_apple_eaten_regular():
	score += 1
	$UI.get_node("Score").text = "Score: " + str(score)
	add_regular_apple()
	snake.ate_apple()

# Built in function to process stuff continually
func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = true
		pause_menu.show()

# If the game starts then start the timer and other stuff
func start_game():
	game_started = true
	$Timer.start()

# Connected to timer node so every time it hits the set time it calls this
func _on_timer_timeout() -> void:
	#can_move = true
	print("Moving Snake")
	snake.move_snake()

func get_random_position() -> Vector2:
	var random_x = randi_range(0, grid_width - 1)
	var random_y = randi_range(0, grid_height -1)
	return Vector2(random_x, random_y)

func game_over():
	game_started = false
	get_tree().paused = true
	game_over_menu.show()

# Game over pop-up buttons

func _on_menu_button_pressed() -> void:
	print("test")
	get_tree().paused = false
	get_tree().change_scene_to_file("res://MainMenu/main_menu.tscn")

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_resume_button_pressed() -> void:
	get_tree().paused = false
	pause_menu.hide()
