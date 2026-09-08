extends Level2D


# @export var spawn_data: MapSpawnData

@export var _player_camera: Camera2D
@export var _player_spawn: Node2D


func get_default_player_spawn() -> Vector2:
	return _player_spawn.global_position


func get_player_camera() -> Camera2D:
	return _player_camera


# func get_spawn_data() -> MapSpawnData:
# 	return spawn_data


# func get_encounter_zones() -> Array[EncounterZone]:
# 	var encounter_zones: Array[EncounterZone] = []
# 	for encounter_zone in $SpawnAreas.get_children():
# 		encounter_zones.append(encounter_zone as EncounterZone)
# 	return encounter_zones
