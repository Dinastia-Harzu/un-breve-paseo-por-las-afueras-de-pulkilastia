@tool

extends Node2D

@export_tool_button("New stroke") var new_stroke_action: Callable = new_stroke
@export var save_path: String = "res://gestures/"
@export var template_name: StringName

@export_tool_button("Save template") var save_template_action: Callable = save_template

@export_group("Saved templates")
@export var a_template: GestureTemplate
@export_tool_button("Load template") var load_template_action: Callable = load_template
@export var root_owning: bool = false


class NewNodeParams:
	var node_class_name: String = "Node2D"
	var root: Node2D = null
	var custom_name: StringName = &""

	func _to_string() -> String:
		return "{ node_class_name: %s, root: %s, custom_name: %s }" % [
			node_class_name,
			root.name if root != null else &"Nil",
			custom_name
		]
	func with_node_class_name(ncn: String) -> NewNodeParams:
		node_class_name = ncn
		return self

	func with_root(r: Node2D) -> NewNodeParams:
		root = r
		return self

	func with_custom_name(cn: StringName) -> NewNodeParams:
		custom_name = cn
		return self


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func new_stroke(root: Node2D = get_tree().edited_scene_root) -> Line2D:
	var new_line: Line2D = Line2D.new()
	add_child(new_line)
	new_line.owner = root
	return new_line


func save_template() -> void:
	var points: Array[QPoint] = []
	var strokes: Array[Node] = get_children()
	for i: int in strokes.size():
		var stroke: Line2D = strokes[i] as Line2D
		for p: Vector2 in stroke.points:
			points.append(QPoint.new(p, i + 1))
	var n: PointCloud = PointCloud.new(points, template_name)
	ResourceSaver.save(
		GestureTemplate.from_point_cloud(n),
		save_path + template_name + ".tres"
	)
	print("Guardado patrón %s en %s" % [template_name, save_path + template_name + ".tres"])

func load_template() -> void:
	if a_template == null:
		return
	var stroke_group := do_add_child_node(
		NewNodeParams.new().with_custom_name(a_template.template_name)
	)
	# var stroke_group: Node2D = Node2D.new()
	# add_child(stroke_group)
	# stroke_group.owner = get_tree().edited_scene_root
	# stroke_group.name = a_template.template_name
	var current_stroke := 0
	var current_line: Line2D = null
	var current_line_points: PackedVector2Array = []
	var points := a_template.positions
	var stroke_ids := a_template.stroke_ids
	for i in points.size():
		if stroke_ids[i] != current_stroke:
			current_line = do_add_child_node(
				NewNodeParams.new()
					.with_node_class_name("Line2D")
					.with_root(stroke_group)
					.with_custom_name("Stroke%d" % stroke_ids[i])
			)
			# current_line = new_stroke()
			# current_line.name = a_template.template_name
			current_line_points = current_line.points
			current_stroke = stroke_ids[i]
		var point := points[i] * 500. + Vector2(500., 250.)
		current_line_points.append(point)
		current_line.points = current_line_points
	print("Patrón %s cargado" % a_template.template_name)


func do_add_child_node(
	params: NewNodeParams = NewNodeParams.new()
) -> Node2D:
	if params.root == null:
		params.root = get_tree().edited_scene_root
	print_debug(params)
	if not ClassDB.class_exists(params.node_class_name):
		print_debug("La clase '%s' no es una clase nativa o no existe" % params.node_class_name)
		return null
	if not ClassDB.is_parent_class(params.node_class_name, "Node2D"):
		print_debug("%s no hereda de Node2D" % params.node_class_name)
		return null
	var new_node: Node = ClassDB.instantiate(params.node_class_name)
	params.root.add_child(new_node)
	new_node.owner = get_tree().edited_scene_root if root_owning else params.root
	new_node.name = params.custom_name
	return new_node
