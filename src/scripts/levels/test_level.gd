extends Level2D


@export var _player_camera: Camera2D
@export var _player_spawn: Node2D


func get_default_player_spawn() -> Vector2:
	return _player_spawn.global_position


func get_player_camera() -> Camera2D:
	return _player_camera
