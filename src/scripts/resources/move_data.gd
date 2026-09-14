class_name MoveData
extends Resource


enum MoveType { PHYSICAL, MAGICAL, SPECIAL }


@export var base_damage: int = -1
@export var type: MoveType


func execute(player_stats: Stats, enemy_stats: Stats) -> void:
	pass
