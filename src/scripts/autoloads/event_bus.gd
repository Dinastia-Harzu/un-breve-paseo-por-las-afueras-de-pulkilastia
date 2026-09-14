extends Node


signal spawn_entity(entity: Node2D)
signal spawn_enemy(enemy: MapEnemy)

signal trigger_encounter(enemy: MapEnemy)

signal exit_battle(enemy: MapEnemy)

signal killed_enemy
