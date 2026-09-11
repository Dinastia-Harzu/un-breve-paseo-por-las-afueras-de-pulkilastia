class_name EnemyData
extends Resource


@export_group("Identity")
@export var name: String
@export var map_sprite: Texture2D
@export var battle_sprite: Texture2D

@export_group("Base Stats")
@export var max_hp: int
@export var offense: int
@export var defense: int
@export var intelligence: int
@export var constitution: int
@export var speed: int

@export_group("Rewards")
@export var exp: int
@export var money: int
