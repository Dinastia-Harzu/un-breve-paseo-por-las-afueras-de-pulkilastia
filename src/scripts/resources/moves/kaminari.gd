extends MoveData


func execute(player_stats: Stats, enemy_stats: Stats) -> void:
	var killed := enemy_stats.magic_attack(player_stats, base_damage)
	if killed:
		EventBus.killed_enemy.emit()
