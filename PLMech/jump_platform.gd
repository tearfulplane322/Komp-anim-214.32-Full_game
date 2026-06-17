extends Node3D




func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		body.velocity.y = 8.0
