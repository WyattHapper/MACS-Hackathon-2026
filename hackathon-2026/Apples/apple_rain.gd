extends Area2D

signal eaten_rain

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("snake_head"):
		eaten_rain.emit()
		queue_free()
