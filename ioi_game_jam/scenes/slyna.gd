extends CharacterBody2D

# Variables for movement
@export var speed: float = 125.0  # Horizontal movement speed
@export var gravity: float = 500.0  # Gravity strength
@export var jump_force: float = -250.0  # Jump force (negative because y+ is downward)

@export var wall_jump_force: float = 250  # Horizontal force for wall jump
@export var wall_slide_speed: float = 20.0  # Speed of sliding down walls
@export var wall_jump_grace_time: float = 0.3
@export var wall_jump_cooldown: float = 1

var wall_normal = Vector2.ZERO
var wall_jump_timer: float = 0.0
var wall_jump_cooldown_timer: float = 0.0 

var is_wall_sliding = false

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

	if is_on_wall_only():
		is_wall_sliding = true
		# Store the wall's normal to determine wall jump direction
		wall_normal = get_wall_normal()
		wall_jump_timer = wall_jump_grace_time
	else:
		is_wall_sliding = false
		wall_normal = Vector2.ZERO
		if wall_jump_timer > 0:
			wall_jump_timer -= delta
	if wall_jump_cooldown_timer > 0:
		wall_jump_cooldown_timer -= delta
	# Apply wall slide mechanics
	if is_wall_sliding:
		velocity.y = wall_slide_speed
	else:
		# Normal gravity when not wall sliding
		if not is_on_floor():
			velocity.y += gravity * delta
	# Allow jumping 
	if Input.is_action_just_pressed("Jump"):
		if is_on_floor():
			# Normal jump
			velocity.y = jump_force
		elif (is_wall_sliding or wall_jump_timer > 0)and wall_jump_cooldown_timer <= 0:
			# Wall jump
			velocity.y = jump_force
			# Push away from the wall
			velocity.x = wall_normal.x * wall_jump_force
			wall_jump_timer = 0
			wall_jump_cooldown_timer = wall_jump_cooldown


	var push_force = 80.0

	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is RigidBody2D:
			c.get_collider().apply_central_impulse(-c.get_normal() * push_force)

	# Move the character
	move_and_slide()
