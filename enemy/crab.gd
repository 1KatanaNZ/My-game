extends Area2D

var enemy_death_effect = preload("res://enemy/enemy_death_effect.tscn")

@export var flip_time = 1
@export var damage_amount : int = 1
var direction = 1
var health_amount : int = 3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Timer.wait_time = flip_time


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	translate(Vector2.RIGHT * direction)
	$AnimatedSprite2D.flip_h = direction > 0

func _on_timer_timeout() -> void:
	direction *= -1 
	$Timer.wait_time = flip_time


func _on_hurtbox_area_entered(area: Area2D) -> void:
	print("Hurtbox area entereds")
	if area.get_parent().has_method("get_damage_amount"):
		var node = area.get_parent() as Node
		health_amount -= node.damage_amount
		print("Health amount: ", health_amount)
		
		if health_amount <= 0:
			var enemy_death_effect_instance = enemy_death_effect.instantiate() as Node2D
			enemy_death_effect_instance.global_position = global_position
			get_parent().add_child(enemy_death_effect_instance)
			queue_free()
