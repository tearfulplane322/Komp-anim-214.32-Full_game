extends Interactable


@export var heal_amount: int = 1
@onready var gpuparticles_3d: GPUParticles3D = $GPUParticles3D

func _on_area_3d_body_entered(body: Player) -> void:
	if body is Player:
		gpuparticles_3d.emitting = false
		audio_stream_player.play()
		Body.visible = false
		area_3d.disabled = true
		body.heal(heal_amount)
		await audio_stream_player.finished
		queue_free()