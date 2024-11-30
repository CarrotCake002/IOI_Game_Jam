extends Node2D

# Load the water particle scene
@onready var water_particle_scene = preload("res://scenes/water_particle.tscn")

# Define the point where water particles should be spawned
@export var num_particles = 100
@export var spawn_interval = 0.01  # Spawn a particle every 0.001 seconds (1 ms)
@export var spawn_x_range = Vector2(0, 0)
@export var spawn_y_range = Vector2(0, 0)
var particles_spawned = 0
var accumulated_time = 0.0

func _ready():
	set_process(true)

func _process(delta):
	accumulated_time += delta
	while accumulated_time >= spawn_interval:
		if particles_spawned < num_particles:
			spawn_water_particle()
			particles_spawned += 1
		else:
			set_process(false)
			print("All particles spawned, stopping process")
			return
		accumulated_time -= spawn_interval

func spawn_water_particle():
	var random_x = randi_range(spawn_x_range.x, spawn_x_range.y)
	var random_y = randi_range(spawn_y_range.x, spawn_y_range.y)
	var spawn_point = Vector2(random_x, random_y)

	var water_particle = water_particle_scene.instantiate()
	water_particle.global_position = spawn_point
	add_child(water_particle)
