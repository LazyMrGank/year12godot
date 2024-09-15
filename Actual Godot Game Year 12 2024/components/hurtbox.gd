class_name HurtBox
extends Area3D


signal receive_damage(damage: int)


@export var health: Health

func _ready():
	connect("area_entered", _on_area_entered)

func _on_area_entered(hitbox: HitBox) -> void:
	if hitbox != null:
		
		health.health -= hitbox.damage
		receive_damage.emit(hitbox.damage)
