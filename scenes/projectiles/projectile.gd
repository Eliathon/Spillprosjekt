extends Area2D

@export var speed: float = 400.0
var velocity: Vector2 = Vector2.ZERO

func _process(delta):
	position += velocity * delta

func fire(direction: Vector2):
	velocity = direction * speed

func _on_Projectile_body_entered(body):
	if body.is_in_group("enemies"):
		# Hit the enemy, apply damage
		queue_free()  # Remove the projectile
