@tool
extends Node3D
class_name UpgradeZone


@export var upgrade_cost: int
@export var upgrade_type: UpgradeType
@export var max_level: int

@export var display_text: String = "Увеличивает скорость"
@export var text_color: Color = Color(1, 1, 1, 1)

@onready var label: Label = $SubViewport/Label
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var current_level: int = 0

var anim_finish: bool = false

enum UpgradeType {
	SPEED,
	COIN_MULTIPLIER,
	COIN_MAX_SCORE,
	COIN_DELAY_DECREASE,
	BOMB_DELAY_INCREASE,
	HEART_RESTORE
}

func _on_area_3d_body_entered(body: Player) -> void:
	if body is Player:
		if not max_level_upgrade():
			purchase_upgrade(body)

func _on_area_3d_body_exited(body: Player) -> void:
	if body is Player and anim_finish == true:
		animation_player.play("toggle-off")
		anim_finish = false

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "toggle-on":
		anim_finish = true
		print("anim_finish: ", anim_finish)

func _ready() -> void:
	if label:
		label.text = display_text
		label.modulate = text_color

func purchase_upgrade(player: Player) -> void:
	if upgrade_cost <= player.coin:
		animation_player.play("toggle-on")
		player.coin -= upgrade_cost
		player.hud.update_ui_display()
		print("Улучшение куплено: " + str(upgrade_type))
		cost_increase()
		get_upgrade(player)
		
	else:
		print("Недостаточно монет для покупки улучшения")

func cost_multiplier():
	match upgrade_type:
		UpgradeType.SPEED:
			return 1.5
		UpgradeType.COIN_MULTIPLIER:
			return 2.0
		UpgradeType.COIN_MAX_SCORE:
			return 1.2
		UpgradeType.BOMB_DELAY_INCREASE:
			return 3.0
		UpgradeType.COIN_DELAY_DECREASE:
			return 4.0
		UpgradeType.HEART_RESTORE:
			return 2.5
		
func cost_increase():
	upgrade_cost = int(upgrade_cost * cost_multiplier())
	print("Новая стоимость улучшения: " + str(upgrade_cost))

func get_upgrade(player: Player):
	print("Получено улучшение: " + str(upgrade_type))
	if upgrade_type == UpgradeType.SPEED:
		player.speed += 0.25
	elif upgrade_type == UpgradeType.COIN_MULTIPLIER:
		player.coin_multiplier += 0.5
	elif upgrade_type == UpgradeType.COIN_MAX_SCORE:
		player.combo_multiplier += 1
	elif upgrade_type == UpgradeType.BOMB_DELAY_INCREASE:
		player.bomb_time_increase(0.5)
	elif upgrade_type == UpgradeType.COIN_DELAY_DECREASE:
		player.coin_time_decrease(0.1)
	elif upgrade_type == UpgradeType.HEART_RESTORE:
		player.heart_time_decrease(1.0)

func max_level_upgrade():
	if current_level >= max_level:
		print("Максимальный уровень улучшения достигнут")
		return true
	else:
		current_level += 1
		return false



	



