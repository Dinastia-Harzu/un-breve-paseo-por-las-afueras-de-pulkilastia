extends MoveData


func execute(player_stats: Stats, enemy_stats: Stats) -> void:
	var killed := enemy_stats.physical_attack(player_stats, base_damage)
	if killed:
		EventBus.killed_enemy.emit()
