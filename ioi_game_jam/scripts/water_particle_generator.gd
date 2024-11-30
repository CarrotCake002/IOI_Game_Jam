extends Node2D

# Load the water particle scene
@onready var water_particle_scene = preload("res://scenes/water_particle.tscn")

# Define the point where water particles should be spawned
var spawn_y = 120
var num_particles = 700
var particles_spawned = 0
var spawn_interval = 0.003  # Spawn a particle every 0.001 seconds (1 ms)
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
	var random_x = randi_range(50, 72)
	var random_y = randi_range(80, 220)
	var spawn_point = Vector2(random_x, random_y)

	var water_particle = water_particle_scene.instantiate()
	water_particle.global_position = spawn_point
	add_child(water_particle)
