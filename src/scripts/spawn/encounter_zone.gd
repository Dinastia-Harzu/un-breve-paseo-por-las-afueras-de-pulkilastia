class_name EncounterZone
extends Area2D


@export var _data: EncounterZoneData


func _ready() -> void:
	add_to_group(NodeGroups.ENCOUNTER_ZONES)


func get_data() -> EncounterZoneData:
	return _data
