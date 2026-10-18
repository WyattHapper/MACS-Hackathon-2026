extends Area2D

signal eaten_regular

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("snake_head"):
		eaten_regular.emit()
		queue_free()
