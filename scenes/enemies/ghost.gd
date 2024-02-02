extends CharacterBody2D

func _ready():
	add_to_group("enemies")

func _process(_delta):
	var direction = Vector2(1, 0)
	var speed: int = 250
	
	velocity = direction * speed
	move_and_slide()
