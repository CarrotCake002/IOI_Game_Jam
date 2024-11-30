extends CharacterBody2D

# Variables for movement
@export var speed: float = 125.0  # Horizontal movement speed
@export var gravity: float = 500.0  # Gravity strength
@export var jump_force: float = -200.0  # Jump force (negative because y+ is downward)

func _physics_process(delta: float) -> void:
	var direction: Vector2 = Vector2.ZERO

	# Check for horizontal input
	if Input.is_action_pressed("Left"):  # Default "A" key
		direction.x -= 1
	if Input.is_action_pressed("Right"):  # Default "D" key
		direction.x += 1

	# Apply horizontal movement
	velocity.x = direction.x * speed

	# Apply gravity
	if not is_on_floor():  # Only apply gravity when not on the floor
		velocity.y += gravity * delta

	# Allow jumping
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = jump_force

	# Move the character
	move_and_slide()
