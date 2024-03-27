extends CharacterBody2D

@onready var parent = get_parent() as PathFollow2D
@onready var path_node = get_node("Path2D/PathFollow2D")
var speed: int = 250

func _ready():
	add_to_group("enemies")

func _physics_process(delta):
	if parent is PathFollow2D:
		parent.set_progress(parent.get_progress() + speed * delta)

func despawn():
	if path_node.progress_ratio == 1:
		queue_free()
