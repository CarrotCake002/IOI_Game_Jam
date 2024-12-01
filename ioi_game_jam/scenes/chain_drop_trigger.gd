extends Area2D

# Reference to the PinJoint2D to destroy
@export var pin_joint: NodePath = "../FullChain/Block"

func _on_area2d_body_entered(body: Node) -> void:
	# Check if the entered body is the player
	if body is CharacterBody2D:
		# Get the PinJoint2D node and remove it
		var joint = get_node_or_null(pin_joint)
		if joint:
			joint.queue_free()  # Safely delete the PinJoint2D
			print("PinJoint2D destroyed!")
		else:
			print("Nothing destroyed")
	else:
		print("Nothing entered")
