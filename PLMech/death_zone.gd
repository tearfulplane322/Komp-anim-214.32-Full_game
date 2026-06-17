extends Area3D



func _on_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		body.global_position = Vector3(0, 2, 0)
		body.take_damage(1)
