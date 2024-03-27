extends Node2D

var projectile_scene: PackedScene = preload("res://scenes/projectiles/projectile.tscn")
var ghost_scene: PackedScene = preload("res://scenes/enemies/ghost.tscn")

var can_enemy = true
@onready var ui_node = get_node("UI/Timer/timer_label")

func _process(_delta):
	var timer_on = ui_node.timer_on
	if timer_on:
		if can_enemy:
			spawn_enemy()

func _on_tower_projectile(pos):
	var projectile = projectile_scene.instantiate()
	projectile.position = pos
	$Projectiles.add_child(projectile)

func spawn_enemy():
	can_enemy = false
	$EnemySpawnTimer.start()
	var enemy = ghost_scene.instantiate()
	$Path2D/PathFollow2D.add_child(enemy)
	enemy.position = $Path2D/PathFollow2D.global_position

func _on_enemy_spawn_timer_timeout():
	can_enemy = true
