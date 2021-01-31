extends KinematicBody2D

signal picked_up_sword
signal sword_offscreen(offscreen, pos)

const GRAVITY = 2300
const ALLOWED_BOUNCES = 2

var bounces = ALLOWED_BOUNCES
var active = false
var stuck = false
var vel = Vector2.ZERO
var offscreen = false
var rng = RandomNumberGenerator.new()

func _ready():
	off()
	rng.randomize()
	
func _physics_process(delta):
	if active and not stuck:
		vel.y += GRAVITY * delta
		move_and_slide(vel)
#		if is_on_floor() or is_on_wall() or is_on_ceiling():
#			stuck = true
#			$AnimationPlayer.stop()
#			vel = Vector2.ZERO

func off():
	stuck = false
	active = false
	$AnimationPlayer.stop()
	hide()
	position.y = 10000
	vel = Vector2.ZERO
	$CollisionShape2D.disabled = true


func _on_Player_lost_sword(pos, initialVel):
	$AudioStreamPlayer2D.play()
	vel = initialVel
	position = Vector2(pos.x, pos.y - 50)
	show()
	$AnimationPlayer.play("spin")
	active = true
#	yield(get_tree().create_timer(0.2), "timeout")
	
	$CollisionShape2D.disabled = false
	


func _on_Area2D_body_entered(body):
#	bitwise magic detecting which collision layers to bounce or stick :)
	var hit_sword_sticky_layer = body.get_collision_layer() & 8 == 8 or body.get_collision_layer() & 2 == 2


	if hit_sword_sticky_layer:
		stuck = true
		$AnimationPlayer.stop()
		vel = Vector2.ZERO
	if stuck and body.name == "Player":
		off()
		emit_signal("picked_up_sword")
