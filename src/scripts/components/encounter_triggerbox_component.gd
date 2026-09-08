class_name EncounterTriggerboxComponent
extends Area2D


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(_body: Node2D) -> void:
	EventBus.trigger_encounter.emit(owner)
