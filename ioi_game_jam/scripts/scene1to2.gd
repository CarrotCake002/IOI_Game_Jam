extends Area2D

func _on_body_entered(body):
	if body.name == "Slyna":
		change_scene()

func change_scene():
	get_tree().change_scene_to_file("res://scenes/level2_not_drained.tscn")
