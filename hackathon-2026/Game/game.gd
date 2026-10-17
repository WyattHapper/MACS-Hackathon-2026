extends Node2D

# Variables

@export var snake_cell_scene: PackedScene

var score: int
var game_started: bool = false
var grid_size: int = 20
var cell_size: int = 50

var last_step_data: Array
var current_step_data: Array
var snake: Array

var start_pos = Vector2(0,0)
var up = Vector2(0, -1)
var down = Vector2(0, 1)
var left = Vector2(-1, 0)
var right = Vector2(1, 0)
var move_dir: Vector2
var can_move: bool

func _ready():
	new_game()

func new_game():
	score = 0
	$UI.get_node("Score").text = "Score: " + str(score)
	move_dir = up
	can_move = true
	print("Make")
	make_snake()
	
func make_snake():
	last_step_data.clear()
	current_step_data.clear()
	snake.clear()
	
	for i in range(3):
		add_cell(start_pos + Vector2(0, i))

func add_cell(pos):
	current_step_data.append(pos)
	var snake_cell = snake_cell_scene.instantiate()
	snake_cell.position = (pos * cell_size) + Vector2(0, cell_size)
	add_child(snake_cell)
	snake.append(snake_cell)

func _process(_delta):
	move_snake()
	
func move_snake():
	if can_move:
		if Input.is_action_just_pressed("move_down") and move_dir != up:
			move_dir = down
			can_move = false
			if not game_started:
				start_game()
		if Input.is_action_just_pressed("move_up") and move_dir != down:
			move_dir = up
			can_move = false
			if not game_started:
				start_game()
		if Input.is_action_just_pressed("move_left") and move_dir != right:
			move_dir = left
			can_move = false
			if not game_started:
				start_game()
		if Input.is_action_just_pressed("move_right") and move_dir != left:
			move_dir = right
			can_move = false
			if not game_started:
				start_game()

func start_game():
	game_started = true
	$Timer.start()

func _on_timer_timeout() -> void:
	can_move = true
	
	last_step_data = [] + current_step_data
	current_step_data[0] += move_dir
	for i in range(len(current_step_data)):
		if i > 0:
			current_step_data[i] = last_step_data[i - 1]
		snake[i].position = (current_step_data[i] * cell_size) + Vector2(0, cell_size)
			
