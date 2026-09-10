class_name FiniteStateMachine
extends Node


@export var initial_data := {}

@export var initial_state: FSMNode = null

@onready var state: FSMNode = (func() -> FSMNode: return initial_state if initial_state != null else get_child(0)).call()


func _ready() -> void:
	for state_node: FSMNode in find_children("*", "FSMNode"):
		state_node.finished.connect(_transition_to_next_state)

	_start.call_deferred()


func _unhandled_input(event: InputEvent) -> void:
	state.handle_input(event)


func _process(delta: float) -> void:
	state.update(delta)


func _physics_process(delta: float) -> void:
	state.physics_update(delta)


func _start() -> void:
	await owner.ready
	state.enter("", initial_data)


func _transition_to_next_state(target_state_path: NodePath, data := {}) -> void:
	if not has_node(target_state_path):
		push_error("%s: intentando transicionar al estado %s, pero este no existe" % [owner.name, target_state_path])
		return

	var previous_state_path := state.get_path()
	state.exit()
	state = get_node(target_state_path)
	state.enter(previous_state_path, data)
