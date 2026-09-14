class_name BattleScene
extends Node2D


@export var enemy_sprite: Sprite2D
@export var battle_ui: BattleUI
@export var attack_timer: Timer
@export var qdollar: QDollar

var _map_enemy: MapEnemy:
	set(value):
		_map_enemy = value
		enemy_sprite.texture = value.enemy_data.battle_sprite


func _ready() -> void:
	battle_ui.flee.connect(_on_flee)
	battle_ui.attack.connect(_on_attack)

	attack_timer.timeout.connect(_on_finish_attack)

	enemy_sprite.position = get_viewport_rect().get_center()


func load_enemy(enemy: MapEnemy) -> void:
	_map_enemy = enemy


func _on_flee() -> void:
	EventBus.exit_battle.emit()


func _on_attack() -> void:
	attack_timer.start()


func _on_finish_attack() -> void:
	qdollar.analyse()
	qdollar.remove_lines()
	battle_ui.show_ui()


func _on_win() -> void:
	EventBus.exit_battle.emit(_map_enemy)
