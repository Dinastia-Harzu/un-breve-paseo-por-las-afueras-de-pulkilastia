class_name BattleScene
extends Node2D


@export var enemy_sprite: Sprite2D

var _enemy_data: EnemyData:
	set(value):
		_enemy_data = value
		enemy_sprite.texture = value.battle_sprite


func _ready() -> void:
	enemy_sprite.position = get_viewport_rect().get_center()


func load_enemy(enemy_data: EnemyData) -> void:
	_enemy_data = enemy_data
