extends CharacterBody2D

var bullet = preload("res://bullet/bullet.tscn")

# Statically typed variable
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var muzzle : Marker2D = $Muzzle
# Constants (implicitly statically typed)
const GRAVITY: int = 1000  # Increased gravity for a stronger pull down
const SPEED: int = 250
const JUMP: int = -300  # Adjusted jump strength
const JUMP_HORIZONTAL: int = 100

# Enum (implicitly statically typed)
enum State {Idle, Run, Jump, Shoot}

# Dynamically typed variable
var current_state = State.Idle
var muzzle_position
func _ready():
	# Dynamically typed variable
	var player_name = "Soldier"
	print("Player Name: ", player_name)

	# Statically typed assignment
	current_state = State.Idle
	muzzle_position = muzzle.position
func _physics_process(delta: float) -> void:
	apply_gravity(delta)
	
	player_muzzle_postion()
	player_shooting(delta)
	player_run(delta)
	player_jump(delta)
	
	move_and_slide()

	determine_state()
	
	player_animations()

func apply_gravity(delta: float) -> void:
	# Apply gravity only when not on the floor
	if not is_on_floor():
		velocity.y += GRAVITY * delta

func player_run(_delta: float) -> void:
	# Statically typed variable for direction
	var direction: float = Input.get_axis("move_left", "move_right")
	
	if direction != 0:
		velocity.x = direction * SPEED
		current_state = State.Run
		animated_sprite_2d.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

func player_jump(delta: float) -> void:
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP
		current_state = State.Jump
	elif is_on_floor() and current_state == State.Jump:
		var direction: float = Input.get_axis("move_left", "move_right")
		velocity.x += direction * JUMP_HORIZONTAL * delta


func player_shooting(delta : float):
	var direction: float = Input.get_axis("move_left", "move_right")
	
	if direction != 0 and Input.is_action_just_pressed("shoot"):
		var bullet_instance = bullet.instantiate() as Node2D
		bullet_instance.direction = direction
		bullet_instance.global_position = muzzle.global_position
		get_parent().add_child(bullet_instance)
		current_state = State.Shoot


func player_muzzle_postion():
	var direction: float = Input.get_axis("move_left", "move_right")
	
	if direction > 0:
		muzzle.position.x = muzzle_position.x
	elif direction < 0:
		muzzle.position.x = -muzzle_position.x



func determine_state() -> void:
	# Check the current state based on position
	if is_on_floor():
		if velocity.x == 0:
			current_state = State.Idle
		else:
			current_state = State.Run
	else:
		current_state = State.Jump




func player_animations():
	if current_state == State.Idle:
		animated_sprite_2d.play("idle")
	elif current_state == State.Run and animated_sprite_2d.animation != "run_shoot":
		animated_sprite_2d.play("run")
	elif current_state == State.Jump:
		animated_sprite_2d.play("jump")
	elif current_state == State.Shoot:
		animated_sprite_2d.play("run_shoot")


func _on_hurtbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemy"):
		print("Enemy entered ", body.damage_amount)
		HealthManager.decrease_health(body.damage_amount)
