extends Interactable

@onready var bah: GPUParticles3D = $Bah
@onready var gpuparticles_3d: GPUParticles3D = $GPUParticles3D

@export var damage_value: int = 1
@export var score_penalty: int = 50

func _on_area_3d_body_entered(body: Player) -> void:
	if body is Player:
		gpuparticles_3d.emitting = false
		bah.emitting = true
		Body.visible = false
		area_3d.disabled = true
		audio_stream_player.play()
		body.take_damage(damage_value)
		body.add_score(-score_penalty)
		body.combo_reset()
		await audio_stream_player.finished
		queue_free()


func _on_bah_finished() -> void:
	bah.emitting = false
