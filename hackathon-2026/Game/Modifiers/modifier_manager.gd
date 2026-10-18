extends Node
class_name ModifierManager

# Assign your .tres modifier resources in the Inspector.
@export var available_modifiers: Array[Modifier] = []
var active_modifiers: Array[Modifier] = []
var game: Node2D


# Called by GameController when the game initializes.
func initialize(game_controller: Node2D) -> void:
	game = game_controller


# Pick two distinct modifiers that the player does not already have.
func get_random_choices() -> Array[Modifier]:
	var choices: Array[Modifier] = []

	# exclude already-active modifiers
	var candidates: Array[Modifier] = []

	for modifier in available_modifiers:
		if modifier == null:
			continue

		if modifier not in active_modifiers:
			candidates.append(modifier)

	# Shuffle so the choices are random.
	candidates.shuffle()

	# Return up to two choices, or fewer if there aren't enough.
	for i in range(min(2, candidates.size())):
		choices.append(candidates[i])

	return choices


# Activate a modifier selected by the player.
func activate_modifier(modifier: Modifier) -> void:
	if modifier == null:
		return

	if modifier in active_modifiers:
		return

	active_modifiers.append(modifier)
	modifier.apply(game)


# Tell every active modifier that a regular apple was eaten.
func on_regular_apple_eaten() -> void:
	for modifier in active_modifiers.duplicate():
		modifier.on_apple_eaten(game)


# Remove every active modifier and reset the run.
func reset_run() -> void:
	for modifier in active_modifiers.duplicate():
		modifier.remove(game)

	active_modifiers.clear()
