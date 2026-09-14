class_name GestureTemplate
extends Resource


@export var template_name: String
@export var positions: PackedVector2Array
@export var stroke_ids: PackedInt32Array
@export var lut: PackedInt32Array

@export var associated_move: MoveData

var point_cloud: PointCloud


func _to_string() -> String:
	return "GestureTemplate { template_name: %s, positions: %s, stroke_ids: %s, lut: %s, point_cloud: %s}" % [template_name, positions, lut, stroke_ids, point_cloud]


static func from_point_cloud(pc: PointCloud) -> GestureTemplate:
	var gt := GestureTemplate.new()
	gt.point_cloud = pc
	gt.serialize()
	return gt


func serialize() -> void:
	template_name = point_cloud.gesture_name
	for p in point_cloud.points:
		positions.append(p.position)
		stroke_ids.append(p.stroke_id)
	lut = point_cloud.lut


func deserialize() -> void:
	var points: Array[QPoint] = []
	for i in stroke_ids.size():
		points.append(QPoint.new(positions[i], stroke_ids[i]))
	point_cloud = PointCloud.new(points, template_name, lut)
