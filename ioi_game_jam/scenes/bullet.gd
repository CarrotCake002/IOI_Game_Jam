extends Area2D

var speed = 400
var bullet_direction
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position += bullet_direction * speed * delta
	if not get_viewport_rect().has_point(position):
		queue_free()
	
	pass
