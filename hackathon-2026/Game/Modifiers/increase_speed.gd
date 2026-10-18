extends Modifier
class_name SpeedUp

func apply(game: Node2D) -> void:
	game._increase_snake_speed()

# reset speed to base
func remove(game: Node2D) -> void:
	pass
