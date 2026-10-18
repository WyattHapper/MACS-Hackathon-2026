extends Node2D

# TO DO
# Input buffer?

# Nathan - Cleaning up snake's code and moving it to separate snake_script

### VARIABLES

var option1_stat
var option2_stat

# Exporting snake cell variable to inspector for ease of use
@export var apple_regular_scene: PackedScene
@export var apple_poison_scene: PackedScene
@export var apple_rain_scene: PackedScene
@export var apple_rain_child_scene: PackedScene
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
@onready var select_menu: Control = $SelectMenu

### BUILT INS
# Built in function to run on start
func _ready():
	new_game()

# Built in function to process stuff continually
func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = true
		pause_menu.show()

### GAME START
# Resets score, move_dir, can_move, and makes the snake
func new_game():
	get_tree().paused = false
	game_over_menu.hide()
	pause_menu.hide()
	select_menu.hide()
	score = 0
	$UI.get_node("Score").text = "Score: " + str(score)
	make_snake()
	add_regular_apple()
	start_game()

# Clears snake data and makes a new snake
func make_snake():
	snake.InitializeSnake()

### APPLES
func add_regular_apple():
	var regular_apple = apple_regular_scene.instantiate()
	
	var flag = false #loops until it finds a position thats not inside the snake
	while (!flag):
		flag = true
		regular_apple.position = (get_random_position() * cell_size) + Vector2(0, top_ui_height)
		for cell in snake.snake_cells:
			if regular_apple.position == cell.position:
				flag = false
				
	regular_apple.eaten_regular.connect(_on_apple_eaten_regular)
	add_child.call_deferred(regular_apple)

func add_poison_apple():
	var poison_apple = apple_poison_scene.instantiate()
	
	var flag = false #loops until it finds a position thats not inside the snake
	while (!flag):
		flag = true
		poison_apple.position = (get_random_position() * cell_size) + Vector2(0, top_ui_height)
		for cell in snake.snake_cells:
			if poison_apple.position == cell.position:
				flag = false
				
	poison_apple.eaten_poison.connect(_on_apple_eaten_poison)
	add_child.call_deferred(poison_apple)

func _on_apple_eaten_regular():
	score += 1
	$UI.get_node("Score").text = "Score: " + str(score)
	add_regular_apple()
	if randf() < 0.25:
		add_poison_apple()
	snake.ate_regular_apple()
	snake.reverse_snake()

func _on_apple_eaten_poison():
	score -= 1
	$UI.get_node("Score").text = "Score: " + str(score)
	snake.ate_poison_apple()

func get_random_position() -> Vector2:
	var random_x = randi_range(0, grid_width - 1)
	var random_y = randi_range(0, grid_height -1)
	return Vector2(random_x, random_y)

### GAME START/END/PROGRESS
# Connected to timer node so every time it hits the set time it calls this
func _on_timer_timeout() -> void:
	#can_move = true
	print("Moving Snake")
	snake.move_snake()

# If the game starts then start the timer and other stuff
func start_game():
	game_started = true
	$Timer.start()

func game_over():
	game_started = false
	get_tree().paused = true
	game_over_menu.show()

func on_level_up(option1, option2):
	pause_menu.get_node("Option1 Button").text = "" + str(option1)
	pause_menu.get_node("Option2 Button").text = "" + str(option2)
	option1_stat = 0
	option2_stat = 0
	get_tree().paused = true
	select_menu.show()
	
func level_stat(stat):
	print(stat)
	pass # Change stats here

### MENU BUTTONS
func _on_menu_button_pressed() -> void:
	print("test")
	get_tree().paused = false
	get_tree().change_scene_to_file("res://MainMenu/main_menu.tscn")

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_resume_button_pressed() -> void:
	get_tree().paused = false
	pause_menu.hide()

func _on_option_1_button_pressed() -> void:
	level_stat(option1_stat)
	get_tree().paused = false
	select_menu.hide()

func _on_option_2_button_pressed() -> void:
	level_stat(option2_stat)
	get_tree().paused = false
	select_menu.hide()
