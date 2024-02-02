extends Area2D

@export var speed: float = 400.0
var velocity: Vector2 = Vector2.ZERO

func _ready():
	connect("body_entered", Callable(self, "_on_Projectile_body_entered"))

func _physics_process(delta):
	position += velocity * delta

func fire(direction: Vector2):
	velocity = direction * speed
	rotation = direction.angle()

func _on_Projectile_body_entered(body):
	if body.is_in_group("enemies"):
		print("Hit")
		# Hit the enemy, apply damage
		queue_free()  # Remove the projectile
