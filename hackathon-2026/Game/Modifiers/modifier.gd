extends Resource
class_name Modifier

@export var modifier_name: String = "Unnamed Modifier"
@export_multiline var description: String = ""

# base interface for all modifiers

func apply(game: Node) -> void:
	pass

func remove(game: Node) -> void:
	pass

func on_apple_eaten(game: Node) -> void:
	pass
