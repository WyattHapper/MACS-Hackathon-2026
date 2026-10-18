extends Modifier
class_name TailCut

func apply(game: Node2D) -> void:
	for i in range(2):
		game.snake.remove_tail()
