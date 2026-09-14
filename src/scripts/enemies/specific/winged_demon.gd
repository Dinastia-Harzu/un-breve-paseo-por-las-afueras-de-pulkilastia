extends MapEnemy


@export var movement_component: MovementComponent
@export var fsm: FiniteStateMachine
@export var animation_tree: AnimationTree

var direction: Vector2


func _physics_process(delta: float) -> void:
	if movement_component.is_moving():
		direction = velocity.normalized()

	animation_tree.set("parameters/StateMachine/idle/blend_position", direction)
	animation_tree.set("parameters/StateMachine/walk/blend_position", direction)
	animation_tree.set("parameters/StateMachine/run/blend_position", direction)
