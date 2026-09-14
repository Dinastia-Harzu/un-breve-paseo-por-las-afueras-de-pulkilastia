extends MoveData


func execute(player_stats: Stats, enemy_stats: Stats) -> void:
	player_stats.current_hp *= 1.5
