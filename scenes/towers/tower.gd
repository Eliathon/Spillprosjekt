extends CharacterBody2D

signal projectile(position)

@export var attack_range = 500
var attack_damage
var attack_speed
var can_projectile: bool = true

func _process(_delta):
	if Input.is_action_pressed("primary_action") and can_projectile:
		var projectile_markers = $ProjectileStartPosition.get_children()
		var selected_projectile = projectile_markers[0]
		can_projectile = false
		$ProjectileReloadTimer.start()
		projectile.emit(selected_projectile.global_position)
	
func _on_projectile_reload_timer_timeout():
	can_projectile = true
