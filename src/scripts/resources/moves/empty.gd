extends MoveData


func execute(player_stats: Stats, enemy_stats: Stats) -> void:
	enemy_stats.current_hp = 1
