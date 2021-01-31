extends RayCast2D

var on_tile = false

func _physics_process(delta):
	if is_colliding():
		on_tile = get_collider()
	else:
		on_tile = false
