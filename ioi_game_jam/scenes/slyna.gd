extends CharacterBody2D

# Variables for movement
@export var speed: float = 125.0  # Horizontal movement speed
@export var gravity: float = 500.0  # Gravity strength
@export var jump_force: float = -250.0  # Jump force (negative because y+ is downward)

@export var wall_jump_force: float = 200  # Horizontal force for wall jump
@export var wall_slide_speed: float = 20.0  # Speed of sliding down walls
@export var wall_jump_grace_time: float = 0.3
@export var wall_jump_cooldown: float = 0.5
@export var fire_rate: float = 100000


@onready var bullet_scene = preload("res://scenes/bullet.tscn")

var time_till_fire: float = 0.0
var wall_normal = Vector2.ZERO
var wall_jump_timer: float = 0.0
var wall_jump_cooldown_timer: float = 0.0 

var is_wall_sliding = false


func _physics_process(delta: float) -> void:
	
	var direction: Vector2 = Vector2.ZERO
	time_till_fire += delta
	# Check for horizontal input
	if Input.is_action_pressed("Left"):  # Default "A" key
		direction.x -= 1
	if Input.is_action_pressed("Right"):  # Default "D" key
		direction.x += 1
	if Input.is_action_pressed("shoot") and time_till_fire >= 1.0 / fire_rate:
		shoot()
		time_till_fire = 0.0
	# Apply horizontal movement
	velocity.x = direction.x * speed
	
	# Apply gravity
	if not is_on_floor() and not is_wall_sliding:  # Only apply gravity when not on the floor
		velocity.y += gravity * delta

	handle_wall_slide(delta)
	handle_wall_jump()
	
	# Move the character
	move_and_slide()
	
func shoot():
	var bullet = bullet_scene.instantiate()
	bullet.position = global_position + $Sprite2D.position
	bullet.bullet_direction = (get_global_mouse_position() - $Sprite2D.position).normalized()
	get_parent().add_child(bullet)

func handle_wall_slide(delta: float) -> void:
	var is_pressing_towards_wall = false
	if is_on_wall():
		wall_normal = get_wall_normal()
		is_pressing_towards_wall = (wall_normal.x < 0 and Input.is_action_pressed("Right")) or (wall_normal.x > 0 and Input.is_action_pressed("Left"))
		wall_jump_timer = wall_jump_grace_time
	if is_on_wall() and not is_on_floor() and velocity.y >= 0 and is_pressing_towards_wall:
		is_wall_sliding = true
		wall_jump_timer = wall_jump_grace_time
		velocity.y = wall_slide_speed
	
	
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
	elif not is_on_floor():
		velocity.y += gravity * delta

func handle_wall_jump() -> void:
	if Input.is_action_just_pressed("Jump"):
		if is_on_floor():
			# Normal jump
			velocity.y = jump_force
		elif (is_wall_sliding or wall_jump_timer > 0) and wall_jump_cooldown_timer <= 0:
			# Wall jump
			velocity.y = jump_force
			# Push away from the wall
			velocity.x = wall_normal.x * wall_jump_force
			wall_jump_timer = 0
			wall_jump_cooldown_timer = wall_jump_cooldown
	
