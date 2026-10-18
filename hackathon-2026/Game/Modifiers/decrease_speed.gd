extends Modifier
class_name SpeedDown

func apply(game: Node2D) -> void:
	game._decrease_snake_speed()
