extends CharacterBody2D

@export var speed : float = 200.0
@export var change_direction_threshold : float = 10.0

# Predefined patrol points
var patrol_points : Array[Vector2] = [
	Vector2(100, 100),
	Vector2(300, 100),
	Vector2(300, 300),
	Vector2(100, 300)
]

var current_point_index : int = 0
var animation_player : AnimationPlayer

func _ready() -> void:
	if patrol_points.size() > 0:
		position = patrol_points[current_point_index]
	
	# Initialize the AnimationPlayer
	animation_player = $AnimationPlayer

	# Start with the idle animation
	animation_player.play("idle")

func _physics_process(delta: float) -> void:
	if patrol_points.size() == 0:
		return

	var target_point = patrol_points[current_point_index]
	var direction = (target_point - position).normalized()
	velocity = direction * speed

	# Move and slide the character using the velocity property
	move_and_slide()

	# Update animation based on movement
	if velocity.length() > 0:
		if animation_player.current_animation != "walk":
			animation_player.play("walk")
	else:
		if animation_player.current_animation != "idle":
			animation_player.play("idle")

	# Check if the enemy is close enough to the target point to switch to the next point
	if position.distance_to(target_point) < change_direction_threshold:
		current_point_index = (current_point_index + 1) % patrol_points.size()
