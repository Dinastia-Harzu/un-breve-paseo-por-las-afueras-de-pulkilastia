class_name Root
extends Node


const PLAYER_SCENE_UID := "uid://bbiwoqwac0ted"
const TEST_LEVEL_UID := "uid://ck5t7o3afxyuk"
const BATTLE_SCENE_UID := "uid://dc7eiankurnrj"

const BATTLE_TRANSITION := preload("uid://ckhiayfi82ngg")
const BATTLE_ENDED_TRANSITION := preload("uid://dsdkwvfvtp5am")
const BACK_TO_LEVEL_TRANSITION := preload("uid://ck5bctjfx6mma")

@export var debug_mode := false:
	set(value):
		debug_mode = value
		if not is_node_ready():
			return
		debug_root.visible = value

var player: Player = null

var _current_level: Level2D = null
var _current_battle_scene: BattleScene = null
var _transition_stack: Array[Transition] = []

var _paused := false:
	set(value):
		_paused = value
		get_tree().paused = value
		pause_root.visible = _paused

@onready var world: Node2D = %World
@onready var battle: Node2D = %Battle

@onready var level_root: Node2D = %LevelRoot
@onready var entity_root: Node2D = %EntityRoot
@onready var effect_root: Node2D = %EffectRoot

@onready var hud_root : Control = %HUDRoot
@onready var pause_root: Control = %PauseRoot
@onready var transition_root: Control = %TransitionRoot
@onready var debug_root: Control = %DebugRoot


func _ready() -> void:
	debug_root.visible = debug_mode

	_init_player()
	load_level(TEST_LEVEL_UID)

	_connect_signals()


func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed(InputActions.DEBUG_QUIT):
		Globals.quit_game()
	elif event.is_action_pressed(InputActions.DEBUG_TOGGLE):
		debug_mode = not debug_mode
	elif event.is_action_pressed(InputActions.PAUSE):
		_paused = not _paused
	elif event.is_action_pressed(InputActions.DEBUG_EXIT_BATTLE):
		exit_battle()


func halt_execution() -> void:
	get_tree().paused = true


func resume_execution() -> void:
	get_tree().paused = false


func load_level(level_scene_uid: String) -> void:
	_deferred_load_level.call_deferred(level_scene_uid)


func load_battle_scene(battle_scene_uid: String) -> void:
	var new_battle_scene_packed: PackedScene = ResourceLoader.load(battle_scene_uid, "PackedScene")
	if not Globals.check(new_battle_scene_packed, "No se ha podido cargar lo que sea esto: %s" % battle_scene_uid):
		return

	var new_battle_scene := new_battle_scene_packed.instantiate()

	if not Globals.check(new_battle_scene, "No se ha podido instanciar la escena de batalla con UID %s" % battle_scene_uid):
		return

	if not new_battle_scene is BattleScene:
		new_battle_scene.free()
		push_error("Lo que sea que hayas pasado no hereda de `BattleScene`")
		return

	_current_battle_scene = new_battle_scene as BattleScene

	battle.add_child(_current_battle_scene)


func enter_battle(enemy: MapEnemy) -> void:
	halt_execution()

	hud_root.hide()
	
	await play_transition(BATTLE_TRANSITION)

	load_battle_scene(BATTLE_SCENE_UID)
	_current_battle_scene.load_enemy(enemy)

	resume_execution()

	world.process_mode = Node.PROCESS_MODE_DISABLED
	world.hide()
	battle.process_mode = Node.PROCESS_MODE_PAUSABLE
	battle.show()


func exit_battle() -> void:
	halt_execution()

	await play_transition(BATTLE_ENDED_TRANSITION, true)

	_current_battle_scene.queue_free()
	_current_battle_scene = null

	battle.process_mode = Node.PROCESS_MODE_DISABLED
	battle.hide()
	world.show()

	await get_tree().process_frame

	await play_transition(BACK_TO_LEVEL_TRANSITION)

	resume_execution()

	world.process_mode = Node.PROCESS_MODE_PAUSABLE


func load_transition(transition_packed: PackedScene) -> Transition:
	var transition_node := transition_packed.instantiate()
	assert(transition_node != null, "No se ha podido instanciar la transición")

	var transition := transition_node as Transition
	assert(transition != null, "Esto no es una transición")

	transition_root.add_child(transition)

	return transition


func play_transition(transition_packed: PackedScene, hold: bool = false):
	var transition := load_transition(transition_packed)
	_empty_transition_stack()

	transition.play()
	await transition.finished
	transition.reset()

	if hold:
		_transition_stack.push_back(transition)
	else:
		transition.queue_free()


func _empty_transition_stack() -> void:
	while not _transition_stack.is_empty():
		_transition_stack.pop_back().queue_free()


func _init_player() -> void:
	var player_scene: PackedScene = ResourceLoader.load(PLAYER_SCENE_UID, "PackedScene")
	assert(player_scene != null, "No se ha podido cargar la escena del jugador, ¿por qué?")

	player = player_scene.instantiate() as Player
	assert(player != null, "La escena con UID %s no hereda de `Player`" % PLAYER_SCENE_UID)

	entity_root.add_child(player)


func _deferred_load_level(level_scene_uid: String) -> void:
	if Globals.check(_current_level):
		_current_level.queue_free()
		_current_level = null
		await get_tree().process_frame

	var new_level_packed: PackedScene = ResourceLoader.load(level_scene_uid, "PackedScene")
	if not Globals.check(new_level_packed, "No se ha podido cargar lo que sea esto: %s" % level_scene_uid):
		return

	var new_level := new_level_packed.instantiate()

	if not Globals.check(new_level, "No se ha podido instanciar el nivel con UID %s" % level_scene_uid):
		return

	if not new_level is Level2D:
		new_level.free()
		push_error("Lo que sea que hayas pasado no hereda de `Level2D`")
		return

	_current_level = new_level as Level2D

	level_root.add_child(_current_level)

	_place_player_at_level_spawn()
	_setup_level_camera()


func _connect_signals() -> void:
	EventBus.spawn_enemy.connect(_on_spawn_enemy)
	EventBus.trigger_encounter.connect(_on_trigger_encounter)
	EventBus.exit_battle.connect(_on_exit_battle)


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

	player.assign_camera(level_camera)


func _on_spawn_enemy(enemy: MapEnemy) -> void:
	entity_root.add_child(enemy, true)


func _on_trigger_encounter(enemy: MapEnemy) -> void:
	enter_battle(enemy)


func _on_exit_battle(enemy: MapEnemy = null) -> void:
	exit_battle()
	if enemy != null:
		enemy.queue_free()
