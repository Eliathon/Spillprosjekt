extends Area2D

const DamageTypes = preload("res://utils/damage_types.gd").DamageTypes

var speed: int = 1000
var direction: Vector2 = Vector2.UP
var attack_damage = 100
var damage_type = DamageTypes.PHYSICAL

func _process(delta):
	position += direction * speed * delta

func _on_hit(target):
	target.take_damage(attack_damage, damage_type)
	queue_free()
