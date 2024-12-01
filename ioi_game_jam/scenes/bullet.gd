extends RigidBody2D

var speed = 200
var bullet_direction
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	contact_monitor = true
	max_contacts_reported = 1
	linear_velocity = bullet_direction * speed
	
func _physics_process(delta):
	if not get_viewport_rect().has_point(position):
		queue_free()

func _on_body_entered(body):
		queue_free()
