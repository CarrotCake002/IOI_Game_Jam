extends Node

# Define the scene paths
var level1_scene_path = "res://scenes/level1.tscn"
var level2_not_drained_scene_path = "res://scenes/level2_not_drained.tscn"

func _on_ready():
	# Ensure the script is processing input and the process function
	set_process(true)
	set_process_input(true)

func change_scene():
	# Get the current scene
	var current_scene = get_tree().get_current_scene()

	# Determine the target scene based on the current scene
	var target_scene_path = ""
	if current_scene.scene_file_path == level1_scene_path:
		target_scene_path = level2_not_drained_scene_path
	elif current_scene.scene_file_path == level2_not_drained_scene_path:
		target_scene_path = level1_scene_path

	# Change to the target scene while keeping the state
	if target_scene_path != "":
		print("Changing scene to:", target_scene_path)
		get_tree().change_scene_to_file(target_scene_path)
