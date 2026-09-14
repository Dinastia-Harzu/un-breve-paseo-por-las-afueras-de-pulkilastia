class_name BattleUI
extends Control


signal flee
signal attack


@export var _buttons_container: Control
@export var _flee_button: Button
@export var _attack_button: Button
@export var _player_stats_box: Control
@export var _attack_ui: Control


func _ready() -> void:
	_flee_button.pressed.connect(_on_flee_selected)
	_attack_button.pressed.connect(_on_attack_selected)


func show_ui() -> void:
	_buttons_container.show()
	_player_stats_box.show()
	_attack_ui.hide()


func _hide_ui() -> void:
	_buttons_container.hide()
	_player_stats_box.hide()


func _on_flee_selected() -> void:
	_hide_ui()
	flee.emit()


func _on_attack_selected() -> void:
	_hide_ui()
	_attack_ui.show()
	attack.emit()
