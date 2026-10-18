extends Area2D

signal eaten_rain_child

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("snake_head"):
		eaten_rain_child.emit()
		queue_free()
