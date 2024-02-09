extends CharacterBody2D

signal projectile_fired(position)

var projectile_scene: PackedScene = preload("res://scenes/projectiles/projectile.tscn")
@export var attack_range = 500
var attack_damage
var attack_speed
var can_projectile: bool = true

var enemies_in_range = []
var intercept_point: Vector2  # Declare intercept_point at a class level

func _ready():
	if not $AttackRange.is_connected("body_entered", Callable(self, "_on_AttackRange_body_entered")):
		$AttackRange.connect("body_entered", Callable(self, "_on_AttackRange_body_entered"))
	if not $AttackRange.is_connected("body_exited", Callable(self, "_on_AttackRange_body_exited")):
		$AttackRange.connect("body_exited", Callable(self, "_on_AttackRange_body_exited"))
	if not $ProjectileReloadTimer.is_connected("timeout", Callable(self, "_on_projectile_reload_timer_timeout")):
		$ProjectileReloadTimer.connect("timeout", Callable(self, "_on_projectile_reload_timer_timeout"))

	# Initialize attack_speed with a non-null value
	attack_speed = 800  # Example value, adjust as needed

func _process(_delta):
	if enemies_in_range.size() > 0:
		# Aim at the first enemy in the list
		var target_enemy = enemies_in_range[0]
		var predicted_position = predict_intercept_point(global_position, target_enemy.global_position, target_enemy.velocity, attack_speed)
		
		if predicted_position != null:
			intercept_point = predicted_position
			look_at(intercept_point)  # Aim towards the predicted intercept point

		# Fire at the enemy if possible
		if can_projectile:
			fire_at_enemy(target_enemy)

		print(enemies_in_range)
	else:
		intercept_point = Vector2()  # Reset intercept point when there are no enemies

func fire_at_enemy(enemy):
	can_projectile = false
	var enemy_pos = enemy.global_position
	var enemy_velocity = enemy.velocity # Use the actual velocity of the enemy

	# Make sure to assign a value to attack_speed, which is the speed of your projectile
	attack_speed = 800 # For example

	# Predict where the enemy will be in the future
	intercept_point = predict_intercept_point(global_position, enemy_pos, enemy_velocity, attack_speed)

	# Only fire if we have a valid intercept point
	if intercept_point != null:
		# Aim the tower towards the intercept point
		look_at(intercept_point)
		
		var projectile = projectile_scene.instantiate()
		get_parent().add_child(projectile)
		projectile.global_position = global_position
		var direction = (intercept_point - global_position).normalized()
		projectile.fire(direction)
		$ProjectileReloadTimer.start()
	else:
		can_projectile = true  # If we can't fire, allow the tower to try again next frame

func predict_intercept_point(tower_pos, enemy_pos, enemy_velocity, projectile_speed):
	# Add a check for null or incorrect values
	if enemy_velocity == null or projectile_speed == null:
		print("Enemy velocity or projectile speed is null.")
		return null
	var to_enemy = enemy_pos - tower_pos
	var a = enemy_velocity.length_squared() - projectile_speed * projectile_speed
	var b = 2.0 * to_enemy.dot(enemy_velocity)
	var c = to_enemy.length_squared()
	
	var discriminant = b * b - 4.0 * a * c
	if discriminant < 0:
		print("No solution found; enemy can't be hit based on current trajectory.")
		return null
	
	var sqrt_discriminant = sqrt(discriminant)
	var t1 = (-b - sqrt_discriminant) / (2.0 * a)
	var t2 = (-b + sqrt_discriminant) / (2.0 * a)
	
	# We want the smallest positive time
	var t = 0
	if t1 > 0 and t2 > 0:
		t = min(t1, t2)
	elif t1 > 0:
		t = t1
	elif t2 > 0:
		t = t2
	else:
		print("Both interception times are negative; enemy has already passed or is too fast.")
		return null
	
	# Calculate the future position based on the interception time
	var future_position = enemy_pos + enemy_velocity * t
	return future_position

func _on_AttackRange_body_entered(body):
	if body.is_in_group("enemies"):
		enemies_in_range.append(body)

func _on_AttackRange_body_exited(body):
	if body.is_in_group("enemies"):
		enemies_in_range.erase(body)

func _on_projectile_reload_timer_timeout():
	can_projectile = true
