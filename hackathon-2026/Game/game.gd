extends Node2D

# TO DO
# Input buffer?

# Nathan - Cleaning up snake's code and moving it to separate snake_script

### VARIABLES
var options: Array[Modifier] = []
var option1_stat: Modifier
var option2_stat: Modifier

var xp: int = 0

var pending_items: Array = []

# Exporting snake cell variable to inspector for ease of use
@export var brick_scene: PackedScene

@export var apple_regular_scene: PackedScene
@export var apple_poison_scene: PackedScene
@export var apple_rain_scene: PackedScene
@export var apple_rain_child_scene: PackedScene
@export var apple_reverse_scene: PackedScene

@export var grid_width: int = 16
@export var grid_height: int = 10

# set base speed
@onready var timer = $Timer

# General game variables
var score: int
var score_multiply = 1
var game_started: bool = false
@export var cell_size: int = 50
@export var top_ui_height: int = 40

#Snake reference
@onready var snake = $Snake

#Modifiers reference
@onready var modifier_manager: ModifierManager = $ModifierManager

# End menu reference
@onready var game_over_menu: Control = $GameOverMenu
@onready var pause_menu: Control = $PauseMenu
@onready var select_menu: Control = $SelectMenu

### BUILT INS
# Built in function to run on start
func _ready():
	modifier_manager.initialize(self)
	new_game()
# Built in function to process stuff continually
func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = true
		pause_menu.show()
	
	if xp >= 2:
		options = modifier_manager.get_random_choices()
		var option1 = options[0]
		var option2 = options[1]
		on_level_up(option1, option2)

### GAME START
# Resets score, move_dir, can_move, and makes the snake
func new_game():
	for item in get_tree().get_nodes_in_group("item"):
		item.queue_free()
		
	pending_items.clear()
		
	get_tree().paused = false
	
	game_over_menu.hide()
	pause_menu.hide()
	select_menu.hide()
	
	score = 0
	xp = 0
	update_score(0)
	make_snake()
	
	add_apple(apple_regular_scene, "eaten_regular")
	
	add_apple(brick_scene, "", "snake_collide")
	
	start_game()

# Clears snake data and makes a new snake
func make_snake():
	snake.InitializeSnake()

### APPLES
func add_apple(apple_scene: PackedScene, eaten_signal: String = "", collision_signal: String = ""):
	var item = apple_scene.instantiate()
	place_apple(item)

	if eaten_signal != "":
		item.connect(eaten_signal, Callable(self, "_on_apple_eaten_" + eaten_signal.trim_prefix("eaten_")))

	if collision_signal != "":
		item.connect(collision_signal, Callable(snake, "_on_snake_collide"))
	
	item.add_to_group("item")
	pending_items.append(item)
	item.tree_entered.connect(func(): pending_items.erase(item))
	add_child.call_deferred(item)


func place_apple(apple):
	var flag = false #loops until it finds a position thats not inside the snake
	while (!flag):
		flag = true
		apple.position = (get_random_position() * cell_size) + Vector2(0, top_ui_height)
		
		# Snake cells
		for cell in snake.snake_cells:
			if apple.position == cell.position:
				flag = false
				break
		
		# Items
		if flag:
			for item in get_tree().get_nodes_in_group("item") + pending_items:
				if item == apple:
					continue
				if apple.position == item.position:
					flag = false
					break

func _on_apple_eaten_regular():
	update_score(1)
	add_apple(apple_regular_scene, "eaten_regular")
	modifier_manager._on_apple_eaten()
	
	var poison_spawned = false
	var reverse_spawned = false
	var rain_spawned = false
	
	if randf() < 0.20:
		add_apple(apple_poison_scene, "eaten_poison")
		poison_spawned = true

	#disabled spawning reverse apples since its in modifiers
	#if not poison_spawned and randf() < 0.20:
	#	add_apple(apple_reverse_scene, "eaten_reverse")
	#	reverse_spawned = true
	
	if not reverse_spawned and randf() < 0.10:
		add_apple(apple_rain_scene, "eaten_rain")
		rain_spawned = true
	
	if not rain_spawned and randf() < 0.06:
		add_apple(brick_scene, "", "snake_collide")
	
	xp += 1
	snake.ate_regular_apple()

func _on_apple_eaten_poison():
	update_score(-1)
	snake.ate_poison_apple()

func _on_apple_eaten_rain():
	update_score(1)
	if randf() < 0.25:
		for i in range(5):
			add_apple(apple_rain_child_scene, "eaten_rain_child")
	else:
		for i in range(3):
			add_apple(apple_rain_child_scene, "eaten_rain_child")
	
	xp += 1
	snake.ate_regular_apple()

func _on_apple_eaten_rain_child():
	update_score(1)
	
	xp += 1
	snake.ate_regular_apple()

func _on_apple_eaten_reverse():
	update_score(1)
	snake.reverse_snake()
	
	xp += 1
	snake.ate_regular_apple()

func update_score(amount: int):
	if amount > 0:
		score += (amount * score_multiply)
	else:
		score += amount
	$UI.get_node("Score").text = "Score: " + str(score)

func get_random_position() -> Vector2:
	var random_x = randi_range(0, grid_width - 1)
	var random_y = randi_range(0, grid_height -1)
	return Vector2(random_x, random_y)

### GAME START/END/PROGRESS
# Connected to timer node so every time it hits the set time it calls this
func _on_timer_timeout() -> void:
	#can_move = true
	snake.move_snake()

# If the game starts then start the timer and other stuff
func start_game():
	game_started = true
	timer.start()

func game_over():
	game_started = false
	get_tree().paused = true
	game_over_menu.show()

func on_level_up(option1: Modifier, option2: Modifier) -> void:
	option1_stat = option1
	option2_stat = option2

	select_menu.get_node("Option1 Button").text = option1.modifier_name
	select_menu.get_node("Option2 Button").text = option2.modifier_name

	xp = 0
	get_tree().paused = true
	select_menu.show()

func level_stat(stat):
	if stat == "Speed Up":
		timer.wait_time -= 0.05
	if stat == "Speed Down":
		timer.wait_time += 0.05
	if stat == "Bonus Score":
		update_score(10)
	if stat == "Score Multiply":
		score_multiply += 1

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
	modifier_manager.activate_modifier(option1_stat)
	get_tree().paused = false
	select_menu.hide()

func _on_option_2_button_pressed() -> void:
	modifier_manager.activate_modifier(option2_stat)
	get_tree().paused = false
	select_menu.hide()
	
	
#MODIFIER FUNCTIONS
func _increase_snake_speed() -> void:
	timer.wait_time -= 0.025

func _decrease_snake_speed() ->void:
	timer.wait_time += 0.025

func _shuffle() -> void:
	var available_positions: Array[Vector2] = []

	# Collect every grid position that isn't occupied by the snake.
	for x in range(grid_width):
		for y in range(grid_height):
			var pos = Vector2(x, y) * cell_size + Vector2(0, top_ui_height)

			var occupied = false

			for cell in snake.snake_cells:
				if pos == cell.position:
					occupied = true
					break

			if not occupied:
				available_positions.append(pos)

	# Randomize the order of available positions.
	available_positions.shuffle()

	# Move each item to a unique available position.
	var items = get_tree().get_nodes_in_group("item")

	for i in range(min(items.size(), available_positions.size())):
		items[i].position = available_positions[i]
