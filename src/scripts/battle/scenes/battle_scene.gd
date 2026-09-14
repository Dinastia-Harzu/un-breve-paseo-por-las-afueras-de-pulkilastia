class_name BattleScene
extends Node2D


@export var enemy_sprite: Sprite2D
@export var battle_ui: BattleUI
@export var attack_timer: Timer

var qdollar_packed := preload("res://src/scenes/gestures/qdollar.tscn")

var _moves: Dictionary[String, MoveData] = {}

var _qdollar: QDollar

var _map_enemy: MapEnemy = null:
	set(value):
		_map_enemy = value
		if value != null:
			enemy_sprite.texture = value.enemy_data.battle_sprite
var _player_data: PlayerData = null


func _ready() -> void:
	_qdollar = qdollar_packed.instantiate()

	battle_ui.flee.connect(_on_flee)
	battle_ui.attack.connect(_on_attack)

	attack_timer.timeout.connect(_on_finish_attack)

	EventBus.killed_enemy.connect(_on_win)

	enemy_sprite.position = get_viewport_rect().get_center()


func load_enemy(enemy: MapEnemy) -> void:
	_map_enemy = enemy


func assign_player_data(player_data: PlayerData) -> void:
	_player_data = player_data


func _on_flee() -> void:
	EventBus.exit_battle.emit()


func _on_attack() -> void:
	add_child(_qdollar)
	attack_timer.start()


func _on_finish_attack() -> void:
	var result := _qdollar.analyse()
	var selected_move := QDollarUtils.associated_moves[result.name]
	selected_move.execute(_player_data.stats, _map_enemy.enemy_data.stats)

	_qdollar.clear()
	remove_child(_qdollar)
	battle_ui.show_ui()


func _on_win() -> void:
	EventBus.exit_battle.emit(_map_enemy)
