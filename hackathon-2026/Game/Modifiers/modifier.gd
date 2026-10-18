extends Resource
class_name Modifier

@export var modifier_name: String = "Unnamed Modifier"
@export_multiline var description: String = ""

# base interface for all modifiers

func apply(_game: Node2D) -> void:
	pass

func remove(_game: Node2D) -> void:
	pass

func on_apple_eaten(_game: Node2D) -> void:
	pass
