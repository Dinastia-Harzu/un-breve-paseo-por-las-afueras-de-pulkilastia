class_name Spawner
extends Marker2D


signal available(this: Spawner)


var _spawnee: MapEnemy = null

var _alive := false:
	set(value):
		_alive = value
		if not value:
			available.emit(self)


func spawn(spawnee: MapEnemy) -> void:
	self._spawnee = spawnee
	spawnee.tree_exiting.connect(_on_enemy_despawned)
	EventBus.spawn_enemy.emit(spawnee)
	_alive = true


func can_spawn() -> bool:
	return not _alive


func make_spawn() -> void:
	if _spawnee != null:
		push_warning("Sobreescribiendo la posibilidad de %s de spawnear cuando su entidad sigue viva" % self)
	_alive = false


func _on_enemy_despawned() -> void:
	_spawnee = null
	make_spawn()
