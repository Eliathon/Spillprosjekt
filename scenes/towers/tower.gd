extends CharacterBody2D

signal projectile_fired(position)

var projectile_scene: PackedScene = preload("res://scenes/projectiles/projectile.tscn")

@export var attack_range = 500
var attack_damage
var attack_speed
var can_projectile: bool = true

var enemies_in_range = []

func _ready():
	if not $AttackRange.is_connected("body_entered", Callable(self, "_on_AttackRange_body_entered")):
		$AttackRange.connect("body_entered", Callable(self, "_on_AttackRange_body_entered"))
	if not $AttackRange.is_connected("body_exited", Callable(self, "_on_AttackRange_body_exited")):
		$AttackRange.connect("body_exited", Callable(self, "_on_AttackRange_body_exited"))
	if not $ProjectileReloadTimer.is_connected("timeout", Callable(self, "_on_projectile_reload_timer_timeout")):
		$ProjectileReloadTimer.connect("timeout", Callable(self, "_on_projectile_reload_timer_timeout"))


func _process(_delta):
	if enemies_in_range.size() > 0 and can_projectile:
		#Target the first enemy in the list
		fire_at_enemy(enemies_in_range[0])
	print(enemies_in_range)

func fire_at_enemy(enemy):
	can_projectile = false
	var projectile = projectile_scene.instantiate()
	get_parent().add_child(projectile)
	projectile.global_position = global_position
	var direction = (enemy.global_position - global_position).normalized()
	projectile.fire(direction)
	$ProjectileReloadTimer.start()

func _on_AttackRange_body_entered(body):
	if body.is_in_group("enemies"):
		enemies_in_range.append(body)

func _on_AttackRange_body_exited(body):
	if body.is_in_group("enemies"):
		enemies_in_range.erase(body)

func _on_projectile_reload_timer_timeout():
	can_projectile = true
