extends Node
class_name MainLevel

var coin_scene = preload("res://PLMech/coin_interactable.tscn")
var bomb_scene = preload("res://PLMech/bomb_interactable.tscn")
var heart_scene = preload("res://PLMech/heart_interactable.tscn")

@onready var coin_timer: Timer = $CoinTimer
@onready var bomb_timer: Timer = $BombTimer
@onready var heart_timer: Timer = $HeartTimer
@onready var player: Player = $Player
@onready var camera: Camera3D = $StartGame/Camera3D
@onready var pos1_marker: Marker3D = $StartGame/CameraPos/POS1Marker3D
@onready var pos2_marker: Marker3D = $StartGame/CameraPos/POS2Marker3D
@onready var pos3_marker: Marker3D = $StartGame/CameraPos/POS3Marker3D

var coin_wait_time: float
var bomb_wait_time: float
var heart_wait_time: float

var game_started: bool = false
var inside_start_area: bool = false
var inside_game_area: bool = false
var inside_upgrade_area: bool = false
var camera_tween = null

func _ready() -> void:
	coin_wait_time = coin_timer.wait_time
	bomb_wait_time = bomb_timer.wait_time
	heart_wait_time = heart_timer.wait_time
	stop_spawners()
	move_camera_to_marker(pos1_marker, 0.0)

func _on_coin_timer_timeout():
	var coin = coin_scene.instantiate()
	var coin_spawn_location = get_node("SpawnPath/SpawnLocation")
	coin_spawn_location.progress_ratio = randf()
	var player_position = player.position
	coin.initialize(coin_spawn_location.position, player_position)
	add_child(coin)

func _on_bomb_timer_timeout() -> void:
	var bomb = bomb_scene.instantiate()
	var bomb_spawn_location = get_node("SpawnPath/SpawnLocation")
	bomb_spawn_location.progress_ratio = randf()
	var player_position = player.position
	bomb.initialize(bomb_spawn_location.position, player_position)
	add_child(bomb)

func _on_heart_timer_timeout() -> void:
	var heart = heart_scene.instantiate()
	var heart_spawn_location = get_node("SpawnPath/SpawnLocation")
	heart_spawn_location.progress_ratio = randf()
	var player_position = player.position
	heart.initialize(heart_spawn_location.position, player_position)
	add_child(heart)



func _on_game_area_3d_body_entered(body: Player) -> void:
	if body is Player:
		move_camera_to_marker(pos1_marker)

func _on_upgrade_area_3d_body_entered(body: Player) -> void:
	if body is Player:
		move_camera_to_marker(pos2_marker)
		stop_game()
		
func _on_start_game_area_3d_body_entered(body: Player) -> void:
	if body is Player:
		move_camera_to_marker(pos3_marker)
		await get_tree().create_timer(1.0).timeout
		start_game()

func start_game() -> void:
	if game_started:
		return
	game_started = true
	coin_timer.start()
	bomb_timer.start()
	heart_timer.start()

func stop_game() -> void:
	if not game_started:
		return
	game_started = false
	stop_spawners()
	reset_player_state()

func stop_spawners() -> void:
	coin_timer.stop()
	bomb_timer.stop()
	heart_timer.stop()

func reset_player_state() -> void:
	player.score = 0
	player.combo = 0
	player.combo_multiplier = 1.0
	player.hp = player.MAX_HP
	player.reset_combo.stop()
	player.hud.update_ui_display()
	player.hud.update_hp_display()

func move_camera_to_marker(marker: Marker3D, duration: float = 2.0) -> void:
	if camera_tween != null:
		camera_tween.kill()
	var target_rotation := camera_rotation_for_marker(marker)
	camera_tween = get_tree().create_tween()
	camera_tween.tween_property(camera, "global_position", marker.global_position, duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	camera_tween.parallel().tween_property(camera, "rotation_degrees", target_rotation, duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

func camera_rotation_for_marker(marker: Marker3D) -> Vector3:
	if marker == pos1_marker:
		return Vector3(-10, 0, 0)
	return Vector3(-65, 0, 0)
