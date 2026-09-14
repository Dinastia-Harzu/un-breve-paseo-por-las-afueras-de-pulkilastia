class_name FSMNode
extends Node


signal finished(next_state_path: NodePath, data: Dictionary)


@export var state_name: String


func handle_input(_event: InputEvent) -> void:
	pass


func update(_delta: float) -> void:
	pass


func physics_update(_delta: float) -> void:
	pass


func enter(previous_state_path: NodePath, data := {}) -> void:
	pass


func exit() -> void:
	pass
