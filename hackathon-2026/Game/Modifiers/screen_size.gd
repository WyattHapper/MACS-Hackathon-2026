extends Modifier
class_name ScreenSize

func apply(game: Node2D) -> void:
	# Increase the grid
	game.grid_width += 4
	game.grid_height += 2

	# Calculate the new playing area size
	var new_width = game.grid_width * game.cell_size
	var new_height = game.grid_height * game.cell_size

	# Increase the viewport size
	game.get_viewport().content_scale_size = Vector2i(
		new_width,
		new_height + game.top_ui_height
	)

	# Increase the actual window size
	DisplayServer.window_set_size(
		Vector2i(new_width, new_height + game.top_ui_height)
	)
