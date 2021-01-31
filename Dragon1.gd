extends KinematicBody2D

const GRAVITY = 1000

var health = 3
var dead = false
var vel = Vector2.ZERO
var facing = -1
var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	
func _physics_process(delta):
	if position.y > 1180:
		position = Vector2(1480, 100)
	if dead:
		die()
	else:
		if not is_on_floor():
			vel.y += delta * GRAVITY
		else:
			vel = Vector2.ZERO
	move_and_collide(vel * delta)
	
func jump():
	if not dead:
		vel = Vector2(facing * 200, -900)
	$AnimatedSprite.play('gust')

func turnaround():
	if not dead and rng.randi_range(0, 10) < 6:
		facing = facing * -1
		scale.x = scale.x * -1

func _on_Area2D_body_entered(body):
	if body.name == "Player":
		body.hit()


func _on_hurtbox_area_entered(area):
	health -= 1
	if health == 0:
		die()
	$fx1.play()
	$coloranim.play("Blink")
	yield(get_tree().create_timer(.3), "timeout")
	$coloranim.play("normal")
	
		
		
func die():
	$claws/CollisionShape2D.disabled = true
	$tail/CollisionShape2D.disabled = true
	yield(get_tree().create_timer(2), "timeout")
	get_tree().change_scene("res://Win.tscn")
