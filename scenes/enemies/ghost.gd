extends CharacterBody2D

func _process(_delta):
	var direction = Vector2(1, 0)
	var speed: int = 500
	
	velocity = direction * speed
	move_and_slide()
