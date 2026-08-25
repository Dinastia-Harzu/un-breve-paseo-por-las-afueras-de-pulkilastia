class_name Root extends Node


const PLAYER_SCENE_UID := "uid://bbiwoqwac0ted"
const TEST_LEVEL := "uid://ck5t7o3afxyuk"

var player: Player = null

var _current_level: Level2D = null

@onready var level_root: Node2D = %LevelRoot
@onready var entity_root: Node2D = %EntityRoot
@onready var effect_root: Node2D = %EffectRoot

@onready var hud_root : Control = %HUDRoot
@onready var pause_root: Control = %PauseRoot
@onready var transition_root: Control = %TransitionRoot
@onready var debug_root: Control = %DebugRoot


func _ready() -> void:
	_init_player()
	load_level(TEST_LEVEL)


func _init_player() -> void:
	var player_scene: PackedScene = ResourceLoader.load(PLAYER_SCENE_UID, "PackedScene")
	assert(player_scene != null, "No se ha podido cargar la escena del jugador, ¿por qué?")

	player = player_scene.instantiate() as Player
	assert(player != null, "La escena con UID %s no hereda de `Player`" % PLAYER_SCENE_UID)

	entity_root.add_child(player)


func load_level(level_scene_uid: String) -> void:
	_deferred_load_level.call_deferred(level_scene_uid)


func _deferred_load_level(level_scene_uid: String) -> void:
	if Globals.check(_current_level):
		_current_level.queue_free()
		_current_level = null

	await get_tree().process_frame

	var new_level_packed: PackedScene = ResourceLoader.load(level_scene_uid, "PackedScene")
	if not Globals.check(new_level_packed, "No se ha podido cargar lo que sea esto: %s" % level_scene_uid):
		return

	_current_level = new_level_packed.instantiate() as Level2D
	if not Globals.check(_current_level, "Lo que sea que hayas pasado no hereda de `Level2D`"):
		return

	level_root.add_child(_current_level)

	await get_tree().process_frame

	_place_player_at_level_spawn()
	_setup_level_camera()


func _place_player_at_level_spawn() -> void:
	if not Globals.check(player, "No se puede colocar al jugador si es null") or \
			not Globals.check(_current_level, "No se puede colocar al jugador en un nivel que no existe"):
		return

	player.global_position = _current_level.get_default_player_spawn()


func _setup_level_camera() -> void:
	if not Globals.check(player) or not Globals.check(_current_level):
		return

	var level_camera := _current_level.get_player_camera()
	if not Globals.check(level_camera):
		return

	level_camera.target = player
