class_name EncounterSpawnerSystem
extends Node


@export var entity_root: Node2D

var _encounter_zones: Array[EncounterZone] = []
var _encounter_zone_table: Dictionary[int, int] = {}


func _process(delta: float) -> void:
	for encounter_zone in _encounter_zones:
		_spawn_in_zone(encounter_zone)

	# for encounter_zone in get_tree().get_nodes_in_group(NodeGroups.ENCOUNTER_ZONES):
	# 	if encounter_zone is EncounterZone:
	# 		encounter_zone.get_data()


func watch_encounter_zones(encounter_zones: Array[EncounterZone]) -> void:
	_encounter_zones = encounter_zones


func _spawn_in_zone(encounter_zone: EncounterZone) -> void:
	var data := encounter_zone.get_data()
	var iid := encounter_zone.get_instance_id()

	var alive: int = _encounter_zone_table.get_or_add(iid, 0)
	if alive < data.max_enemies_alive:
		_spawn_one_of(data.enemies)
		_encounter_zone_table[iid] = alive + 1


func _spawn_one_of(enemies: Array[PackedScene]) -> void:
	var enemy_packed := enemies[randi_range(0, enemies.size() - 1)]
	var enemy := enemy_packed.instantiate()
	entity_root.add_child(enemy)
