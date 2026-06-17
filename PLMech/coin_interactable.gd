extends Interactable

@export var coin_value: int = 1
@export var score_value: int = 10
@export var combo_value: int = 1
@export var multiplier: float = 0.1

@onready var gpuparticles_3d: GPUParticles3D = $GPUParticles3D

func _on_area_3d_body_entered(body: Player) -> void:
	if body is Player:
		gpuparticles_3d.emitting = false
		audio_stream_player.play(0.6)
		Body.visible = false
		area_3d.disabled = true
		body.add_coin(coin_value)
		body.add_score(score_value)
		body.add_combo(combo_value)
		body.combo_multiply(multiplier)
		await audio_stream_player.finished
		queue_free()
