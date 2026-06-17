extends CharacterBody3D
class_name Player


@onready var body: Node3D = $Body
@onready var hud: Control = $Hud	
@onready var reset_combo: Timer = $ResetCombo
@onready var animation_tree: AnimationTree = $Body/Untitled/AnimationTree
@onready var grass := $"../Environment/MultiMeshInstance3D"


const ROTATION_SPEED = 10.0
const MAX_HP = 3

var hp: int = MAX_HP
var speed: float = 5.0

var coin: int = 0
var score: int = 0
var combo: int = 0
var combo_multiplier: float = 1.0
var coin_multiplier: float = 1.0

enum animations {
	IDLE,
	RUN
}

var current_anim = animations.RUN

var levels: MainLevel


func _ready() -> void:
	levels = get_parent()

func _physics_process(delta: float) -> void:
	var mat := grass.material_override as ShaderMaterial
	mat.set_shader_parameter(
		"interracting_object_pos",
		global_position)


	var input_dir := Input.get_vector("Left", "Right", "Forward", "Backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction != Vector3.ZERO:
		var target_yaw := atan2(-direction.x, -direction.z)
		body.rotation.y = lerp_angle(body.rotation.y, target_yaw, ROTATION_SPEED * delta)
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
		current_anim = animations.RUN
		animation_tree.set("parameters/DANCE/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT)
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
		current_anim = animations.IDLE

	hendle_anim()
	move_and_slide()

	if Input.is_action_just_pressed("Esc"):
		get_tree().change_scene_to_file("UI/MainMenu/main_menu.tscn")
	
	if Input.is_action_just_pressed("Use") and current_anim == animations.IDLE:
		animation_tree.set("parameters/DANCE/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
		


func hendle_anim() -> void:
	match current_anim:
		animations.RUN:
			animation_tree.set("parameters/Movement/transition_request", "Run")
		animations.IDLE:
			animation_tree.set("parameters/Movement/transition_request", "Idle")

func add_coin(coin_value: int) -> void:
	coin += int(coin_value * coin_multiplier)
	hud.update_ui_display()

func add_score(score_value: int) -> void:
	score += int(score_value * combo_multiplier)
	hud.update_ui_display()

func add_combo(combo_value: int) -> void:
	combo += combo_value
	reset_combo.start()
	hud.update_ui_display()

func combo_multiply(multiplier: float) -> void:
	combo_multiplier += multiplier
	hud.update_ui_display()

func heal(heal_amount: int) -> void:
	if hp == MAX_HP:
		score += 250
		hud.update_ui_display()
	hp += heal_amount
	hp = min(hp, MAX_HP)
	hud.update_hp_display()


func coin_time_decrease(amount: float) -> void:
	levels.coin_timer.wait_time -= amount

func bomb_time_increase(amount: float) -> void:
	levels.bomb_timer.wait_time += amount

func heart_time_decrease(amount: float) -> void:
	levels.heart_timer.wait_time -= amount

func take_damage(damage: int) -> void:
	hp -= damage
	hp = max(hp, 0)
	hud.update_hp_display()
	if hp == 0:
		die()

func die() -> void:
	get_tree().change_scene_to_file("UI/MainMenu/main_menu.tscn")

func combo_reset() -> void:
	combo = 0
	combo_multiplier = 1.0
	reset_combo.stop()
	hud.update_ui_display()

func _on_reset_combo_timeout() -> void:
	combo_reset()
