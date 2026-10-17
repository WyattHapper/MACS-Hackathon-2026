extends Node

# Snake data
var snake: Array #positions from 0 to grid size counting by 1
var snake_cells: Array # the snake cells with scale

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

#game data
@onready var game = $Game

# Exporting snake cell variable to inspector for ease of use
@export var snake_cell_scene: PackedScene


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	handle_input()


func InitializeSnake():
	move_dir = Vector2.UP
	can_move = true
	snake.clear()
	for i in range(3):
		snake.push_back(start_pos + Vector2(0, i))

# Handles user input
func handle_input() -> void:
	if not can_move:
		return

	for action in input_directions:
		# Goes through "move_up", "move_down" etc and checks if its pressed
		var new_dir: Vector2 = input_directions[action]
		if Input.is_action_just_pressed(action) and new_dir != -move_dir and new_dir != move_dir:
			move_dir = new_dir
			can_move = false

func move_snake() -> void:
	# Copies the current step data into last step and moves the head data
	#last_step_data = current_step_data.duplicate()
	var new_position = snake[0] + move_dir
	
	# Wrap snake to other side
	if new_position.x > game.grid_size:
		new_position.x = 0
	elif new_position.x < 0:
		new_position.x = game.grid_size
	if new_position.y > game.grid_size:
		new_position.y = 0
	elif new_position.y < 0:
		new_position.y = game.grid_size

	# Moves all of the data to be one square ahead
	#for i in range(1, current_step_data.size()):
		#current_step_data[i] = last_step_data[i - 1]

	# Moves the actual snake cell objects one square ahead
	#for i in snake.size():
		#snake[i].position = (current_step_data[i] * cell_size) + Vector2(0, cell_size)
	
	#Previous code not needed, remove the last cell and add a new one to the front
	snake.pop_back()
	snake.push_front(new_position)
	snake_cells.pop_back()
	add_cell(snake[0])

# Adds a cell to the snake
func add_cell(pos):
	# Adding new snake cell object to the array
	var snake_cell = snake_cell_scene.instantiate()
	snake_cell.position = (pos * game.cell_size) + Vector2(0, game.cell_size)
	add_child(snake_cell)
	snake_cells.push_front(snake_cell)
