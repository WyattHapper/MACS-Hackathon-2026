extends Area2D

signal eaten_reverse

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("snake_head"):
		eaten_reverse.emit()
		queue_free()
