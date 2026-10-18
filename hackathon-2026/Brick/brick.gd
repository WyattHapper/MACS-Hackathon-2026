extends Area2D

signal snake_collide

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("snake_head"):
		snake_collide.emit()
