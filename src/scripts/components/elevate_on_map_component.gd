class_name ElevateOnMapComponent
extends Node


@export var elevate_layer: TileMapLayer


func _physics_process(delta: float) -> void:
	var entities := get_tree().get_nodes_in_group(NodeGroups.WORLD_ENTITIES)

	for entity in entities:
		if entity is CharacterBody2D:
			var local_position := elevate_layer.to_local(entity.global_position)
			var mapped := elevate_layer.local_to_map(local_position)

			var tile_data := elevate_layer.get_cell_tile_data(mapped)
			entity.set_collision_mask_value(LayerNames.Physics2D.WATER, not (tile_data and tile_data.get_custom_data("elevate")))

	# var is_elevated := _check_elevated()
	#
	# _set_collision_mask_and_layer(LayerNames.Physics2D.WATER, !is_elevated)


func _check_elevated() -> bool:
	return true


func _set_collision_mask_and_layer(layer: int, value: bool) -> void:
	pass
	# body.set_collision_layer_value(layer, value)
	# body.set_collision_mask_value(layer, value)
