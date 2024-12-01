extends Area2D

@export var distance: float = 50
@export var speed: float = 10
var anger_lvl: int = 0
var is_stone: bool = false
var start_pos: Vector2 
var up_or_down: int = -1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_pos = position
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if not is_stone:
		move_up_and_down(delta)
	#if is_stone:
		#make so you can jump on
	
	pass

func move_up_and_down(delta):

	if position.y >= start_pos.y + distance:
		up_or_down *= -1
	elif position.y <= start_pos.y:
		up_or_down *= -1
		
	position.y -= speed * delta * up_or_down
