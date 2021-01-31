extends Node2D

func _ready():
	$Player.canattack = true
	get_tree().create_timer(3).connect("timeout", self, '_dragon_attack')
	
func _dragon_attack():
	$Dragon.jump()
	nextJump()
	
func nextJump():
	$Dragon.turnaround()
	get_tree().create_timer(3).connect("timeout", self, '_dragon_attack')
