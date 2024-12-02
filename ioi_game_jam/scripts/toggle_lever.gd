extends Area2D

# Load the water particle scene
@onready var water_particle_scene = preload("res://scenes/water_particle.tscn")

# Flag to track if the lever has been run
var lever_run = false
var entered = false

var x = 350
var y = 108

func _on_body_entered(body):
	# Check if the entering body is the character
	if body.name == "Slyna":
		print("Character entered the area")
		entered = true

func _on_body_exited(body):
	# Check if the exiting body is the character
	if body.name == "Slyna":
		print("Character left the area")
		entered = false

func _process(delta):
	if entered:
		check_if_e_key_pressed()

func check_if_e_key_pressed():
	if Input.is_action_just_pressed("Change Map") and not lever_run:
		lever_run = true
		print("E key pressed")
		change_and_destroy_tiles()
		spawn_water_particle()

func change_and_destroy_tiles():
	# Get the TileMap node
	var tilemap = get_parent().get_node("map")

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
