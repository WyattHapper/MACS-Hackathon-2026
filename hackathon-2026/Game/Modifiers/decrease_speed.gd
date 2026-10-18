extends Modifier
class_name SpeedDown

func apply(game: Node2D) -> void:
	game._decrease_snake_speed()

# reset speed to base
func remove(game: Node2D) -> void:
	pass
