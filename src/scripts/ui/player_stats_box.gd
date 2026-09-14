extends Control


@export var player_data: PlayerData

@export var hp_label: Label

var hp: int:
	set(value):
		hp_label.text = "%d/%d" % [value, player_data.max_hp]


func _ready() -> void:
	hp_label.text = "%d/%d" % [player_data.current_hp, player_data.max_hp]
