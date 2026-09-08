class_name EncounterZone
extends Node2D


@export var _debug_camera: Camera2D

@export var _data: EncounterZoneData

var _available_spawners: Array[Spawner] = []


func _ready() -> void:
	for spawner in get_children():
		if spawner is Spawner:
			spawner.available.connect(_on_available)
			if spawner.can_spawn():
				spawner.make_spawn()
			# _spawners.append(spawner)


func _process(delta: float) -> void:
	var fulfilled_spawners: Array[int] = []
	for i in _available_spawners.size():
		var spawner := _available_spawners[i]
		if not _check_spawner_visible(spawner.global_position):
			var enemy_inst := _data.enemies[randi_range(0, _data.enemies.size() - 1)].instantiate()
			assert(enemy_inst != null, "No se puede spawnear este enemigo porque no se puede instanciar")
	
			assert(enemy_inst is MapEnemy, "Esto no es un 'MapEnemy'")
			var enemy = enemy_inst as MapEnemy
	
			enemy.global_position = spawner.global_position
	
			spawner.spawn(enemy)
			fulfilled_spawners.append(i)

	while not fulfilled_spawners.is_empty():
		_available_spawners.remove_at(fulfilled_spawners.pop_back())
	# _available_spawners = _available_spawners.filter(func(s: Spawner): s.can_spawn())


func _check_spawner_visible(spawner_position: Vector2) -> bool:
	const MARGIN_FACTOR := 1.2
	var visible_size := _debug_camera.get_viewport_rect().size / _debug_camera.zoom * MARGIN_FACTOR
	var top_left_position := _debug_camera.get_screen_center_position() - visible_size / 2.
	var camera_rect := Rect2(top_left_position, visible_size)

	return camera_rect.has_point(spawner_position)


func _on_available(spawner: Spawner) -> void:
	_available_spawners.append(spawner)
