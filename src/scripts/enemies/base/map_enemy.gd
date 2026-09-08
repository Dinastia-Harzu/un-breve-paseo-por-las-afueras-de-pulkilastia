class_name MapEnemy
extends CharacterBody2D


@export var enemy_data: EnemyData


func _ready() -> void:
	add_to_group(NodeGroups.WORLD_ENTITIES)
