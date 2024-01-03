extends Node2D

var projectile_scene: PackedScene = preload("res://scenes/projectiles/projectile.tscn")

func _on_tower_projectile(pos):
	var projectile = projectile_scene.instantiate()
	projectile.position = pos
	$Projectiles.add_child(projectile)
