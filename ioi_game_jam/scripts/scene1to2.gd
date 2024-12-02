extends Area2D

var level_to_load: String

func change_scene():
	print(Singleton.water_drained)
	if Singleton.water_drained:
		level_to_load = "res://scenes/level2_drained.tscn"
	else:
		level_to_load = "res://scenes/level2_not_drained.tscn"
	get_tree().change_scene_to_file(level_to_load)


func _on_scene_change_1_area_entered(area: Area2D) -> void:
	if area.name == "PlayerTriggerArea":
		change_scene()


func _on_area_entered(area: Area2D) -> void:
	if area.name == "PlayerTriggerArea":
		change_scene()
