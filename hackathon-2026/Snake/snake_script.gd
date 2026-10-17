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
var just_ate: bool # determines if the tail should move or grow

#game data
@onready var game = $".."

# Exporting snake cell variable to inspector for ease of use
@export var snake_cell_scene: PackedScene


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	handle_input()


func InitializeSnake():
	move_dir = Vector2.UP
	can_move = true
	snake.clear()
	for i in range(3):
		snake.push_front(start_pos + Vector2(0, 2-i))
		add_cell(snake[0])
	print("Snake Initialized")

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
			return

func move_snake() -> void:
	var new_position:Vector2 = snake[0] + move_dir
	
	# Wrap snake to other side
	if new_position.x >= game.grid_width:
		new_position.x = 0
	elif new_position.x < 0:
		new_position.x = game.grid_width-1
	if new_position.y >= game.grid_height:
		new_position.y = 0
	elif new_position.y < 0:
		new_position.y = game.grid_height-1
	
	#remove the last cell and add a new one to the front
	if not just_ate:
		snake.pop_back()
		snake_cells.pop_back().queue_free()
	else:
		just_ate = false
	snake.push_front(new_position)
	add_cell(snake[0])
	can_move = true

# Adds a cell to the snake
func add_cell(pos):
	# Adding new snake cell object to the array
	var snake_cell = snake_cell_scene.instantiate()
	snake_cell.position = (pos * game.cell_size) + Vector2(0, game.top_ui_height)
	add_child(snake_cell)
	
	if snake_cells.size() > 1:
		snake_cells[0].remove_from_group("snake_head")
	
	snake_cell.get_node("SnakeArea").add_to_group("snake_head")
	snake_cell.get_node("SnakeArea").add_to_group("snake")
	snake_cell.get_node("SnakeArea").snake_collide.connect(_on_snake_collide)
	snake_cells.push_front(snake_cell)

func _on_snake_collide():
	pass

func ate_apple() -> void:
	just_ate = true;
