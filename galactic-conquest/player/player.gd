extends CharacterBody2D

# Statically typed variable
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

# Constants (implicitly statically typed)
const GRAVITY: int = 1000  # Increased gravity for a stronger pull down
const SPEED: int = 300
const JUMP: int = -300  # Adjusted jump strength
const JUMP_HORIZONTAL: int = 100

# Enum (implicitly statically typed)
enum State {Idle, Run, Jump}

# Dynamically typed variable
var current_state = State.Idle

func _ready():
	# Dynamically typed variable
	var player_name = "Soldier"
	print("Player Name: ", player_name)

	# Statically typed assignment
	current_state = State.Idle

func _physics_process(delta: float) -> void:
	apply_gravity(delta)

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

func determine_state() -> void:
	# Check the current state based on position
	if is_on_floor():
		if velocity.x == 0:
			current_state = State.Idle
		else:
			current_state = State.Run
	else:
		current_state = State.Jump

func player_animations() -> void:
	match current_state:
		State.Idle:
			animated_sprite_2d.play("idle")
		State.Run:
			animated_sprite_2d.play("run")
		State.Jump:
			animated_sprite_2d.play("jump")
