class_name Health
extends Node3D


signal max_health_changed(diff: int)
signal health_changed(diff: int)
signal health_depleted


@export var max_health: int = 3 : set = set_max_health, get = get_max_health
@export var immortality: bool = false : set = set_immortality, get = get_immortality

var immortality_timer: Timer = null

@onready var health: int = max_health : set = set_health, get = get_health


func set_max_health(value: int):
	pass

func get_max_health() -> int:
	return max_health

func set_immortality(value: bool):
	immortality = value

func get_immortality() -> bool:
	return immortality

func set_health(value: int):
	pass

func get_health():
	return health
