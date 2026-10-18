extends Modifier
class_name SpeedModifier

func apply(game: Node2D) -> void:
	game.speed_multiplier += 0.25
	game.update_snake_speed()

# reset speed to base
func remove(game: Node2D) -> void:
	game.speed_multiplier = 1
	game.update_snake_speed()
