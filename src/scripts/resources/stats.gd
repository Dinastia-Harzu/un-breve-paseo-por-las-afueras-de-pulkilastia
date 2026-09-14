class_name Stats
extends Resource


@export var max_hp: int
@export var current_hp: int:
	set(value):
		current_hp = clampi(0, value, max_hp)
@export var offense: int
@export var defense: int
@export var intelligence: int
@export var constitution: int
@export var speed: int


func physical_attack(offender: Stats, base_damage: int) -> bool:
	current_hp -= _damage_formula(base_damage, offender.offense, defense)
	return current_hp == 0


func magic_attack(offender: Stats, base_damage: int) -> bool:
	current_hp -= _damage_formula(base_damage, offender.intelligence, constitution)
	return current_hp == 0


func _damage_formula(base_damage: int, offensive_stat: int, defensive_stat: int) -> int:
	return .01 * randi_range(85, 100) * offensive_stat * base_damage / (25 * defensive_stat) + 2
