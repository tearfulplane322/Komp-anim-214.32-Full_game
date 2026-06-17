extends Node3D
class_name Interactable

@export var min_speed: int = 5
@export var max_speed: int = 10

@onready var Body: Node3D = $Body
@onready var area_3d: CollisionShape3D = $Area3D/CollisionShape3D
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

var velocity: Vector3 = Vector3.ZERO

func _physics_process(delta: float) -> void:
	position += velocity * delta

func initialize(start_position, player_position):
	look_at_from_position(start_position, player_position, Vector3.UP)
	rotate_y(randf_range(-PI / 4, PI / 4))

	var random_speed = randi_range(min_speed, max_speed)
	velocity = Vector3.FORWARD * random_speed
	velocity = velocity.rotated(Vector3.UP, rotation.y)

func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	queue_free()

func _on_area_3d_body_entered(body: Player) -> void:
	if body is Player:
		pass
