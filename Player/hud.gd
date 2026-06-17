extends Control

@onready var texture_rect: TextureRect = $HP/TextureRect
@onready var texture_rect_2: TextureRect = $HP/TextureRect2
@onready var texture_rect_3: TextureRect = $HP/TextureRect3

@onready var coin: Label = $Coin
@onready var multiplier: Label = $Multiplier
@onready var combo: Label = $Combo
@onready var score: Label = $Score

var player: Player

func _ready() -> void:
	player = get_parent() as Player
	update_hp_display()
	update_ui_display()


func update_hp_display() -> void:
	if player.hp <= 0:
		texture_rect.visible = false
		texture_rect_2.visible = false
		texture_rect_3.visible = false
	elif player.hp == 1:
		texture_rect.visible = true
		texture_rect_2.visible = false
		texture_rect_3.visible = false
	elif player.hp == 2:
		texture_rect.visible = true
		texture_rect_2.visible = true
		texture_rect_3.visible = false
	else:
		texture_rect.visible = player.hp > 0
		texture_rect_2.visible = player.hp > 1
		texture_rect_3.visible = player.hp > 2

func update_ui_display() -> void:
	coin.text = "Монеты: " + str(player.coin)
	combo.text = "Комбо: " + str(player.combo)
	score.text = "Очки: " + str(player.score)
	multiplier.text = "Множитель комбо: " + str(player.combo_multiplier)
