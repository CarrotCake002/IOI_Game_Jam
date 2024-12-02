extends CharacterBody2D

# Variables for movement
@export var speed: float = 125.0  # Horizontal movement speed
@export var gravity: float = 500.0  # Gravity strength
@export var jump_force: float = -200.0  # Jump force (negative because y+ is downward)

@export var wall_jump_force: float = 200  # Horizontal force for wall jump
@export var wall_slide_speed: float = 20.0  # Speed of sliding down walls
@export var wall_jump_grace_time: float = 0.3
@export var wall_jump_cooldown: float = 0.5
@export var fire_rate: float = 1


@onready var bullet_scene = preload("res://scenes/bullet.tscn")
@onready var water_particle_scene = preload("res://scenes/water_particle.tscn")

var time_till_fire: float = 0.0
var wall_normal = Vector2.ZERO
var wall_jump_timer: float = 0.0
var wall_jump_cooldown_timer: float = 0.0 
var release_shoot: bool = true

var is_wall_sliding = false

var lever_run = false
var entered = false

var x = 350
var y = 108

#func _ready():
	#set_collision_layer_value(1, false)
	#set_collision_layer_value(2, true)
	
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	
	var direction: Vector2 = Vector2.ZERO
	
	time_till_fire += delta
	# Check for horizontal input
	
	# Play walking animation if moving
	
	if Input.is_action_pressed("Left"):  # Default "A" key
		direction.x = -1
		animated_sprite_2d.flip_h = true
	if Input.is_action_pressed("Right"):  # Default "D" key
		direction.x = 1
		animated_sprite_2d.flip_h = false

		
	if Input.is_action_pressed("shoot") and release_shoot:
		shoot()
		time_till_fire = 0.0
		release_shoot = false
	# Apply horizontal movement
	if Input.is_action_just_released("shoot"):
		release_shoot = true
	
	
	velocity.x = direction.x * speed
	
	if direction.x == 0:
		animated_sprite_2d.play("idle")
	elif not is_on_floor():
		animated_sprite_2d.play("jump")
	else:
		animated_sprite_2d.play("walking_r")

	# Apply gravity
	if not is_on_floor() and not is_wall_sliding:
		velocity.y += gravity * delta

	handle_wall_slide(delta)
	handle_wall_jump()
	
	
func shoot():
	var bullet = bullet_scene.instantiate()
	var spawn_position = global_position + $CollisionShape2D.position
	bullet.global_position = global_position + $CollisionShape2D.position
	var direction = (get_global_mouse_position() - spawn_position).normalized()
	bullet.bullet_direction = direction
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

	var push_force = 40.0

	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is RigidBody2D:
			c.get_collider().apply_central_impulse(-c.get_normal() * push_force)

	# Move the character
	move_and_slide()
	


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("FireBois"):
		print("Hello, Godot!")
		get_tree().reload_current_scene()



func _on_lever_area_entered(area: Area2D) -> void:
	# Check if the entering body is the character
	if area.name == "TriggerArea":
		print("Character entered the area")
		entered = true


func _on_lever_area_exited(area: Area2D) -> void:
	if area.name == "TriggerArea":
		print("Character left the area")
		entered = false

func _process(delta):
	if entered:
		check_if_e_key_pressed()

func check_if_e_key_pressed():
	if Input.is_action_just_pressed("Interact") and not lever_run:
		lever_run = true
		print("Player Interacted")
		change_and_destroy_tiles()
		spawn_water_particle()

func change_and_destroy_tiles():
	# Get the TileMap node
	var tilemap = get_parent().get_node("map")
	
	if !tilemap:
		print("no tilemap")
	# Change the tile at position 23:3 to the sprite at position 5,8 in the spritesheet
	tilemap.set_cell(Vector2i(23, 3), 0, Vector2i(5, 8))

	# Destroy the tile at position 22:7
	tilemap.erase_cell(Vector2i(22, 7))

func spawn_water_particle():
	var spawn_point = Vector2(x, y)

	var water_particle = water_particle_scene.instantiate()
	water_particle.global_position = spawn_point

	# Ensure the water particle has a proper collision shape
	var collision_shape = water_particle.get_node("CollisionShape2D")
	if collision_shape:
		collision_shape.shape = CircleShape2D.new()
		collision_shape.shape.radius = 5  # Set an appropriate radius

	add_child(water_particle)
