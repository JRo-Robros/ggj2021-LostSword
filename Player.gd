extends KinematicBody2D

signal lost_sword(pos, initialVel)

const JUMPFORCE = -500
const GRAVITY = 2300
const STDSPEED = 200
const MAXSPEED = 355
const AIR_STEER = 10
const SNAPVEC = Vector2.DOWN * 38
const MAX_COYOTE_TIME = 6
const MAX_JUMP_BUFFER = 6

var vulnerable = true
var health = 3
var canattack = false
var attacking = false
var direction = 1
var has_sword = true
var vel = Vector2.ZERO
var speed = STDSPEED
var doubleJumpReady = false
var varjump = false
var snapvector = Vector2.ZERO
var coyoteTime = 0
var jumpBuffer = 0

#measure jump heights
var peak = 0
var inity = 0
var floored = false

var rng = RandomNumberGenerator.new()
func _ready():
	rng.randomize()

func _physics_process(delta):
	
	if Input.is_action_just_pressed("y"):
		var ray = get_node_or_null('./RayCast2D')
		if ray != null:
			if ray.on_tile:
				ray.on_tile.dig()
				
	
	if Input.is_action_just_pressed("x"):
		if has_sword and canattack:
			attack()		
	
	if Input.is_action_pressed("r3") and Input.is_action_pressed("l3"):
		get_tree().change_scene("res://Main.tscn")
		
	if is_on_floor():
		vel.y = 0
		snapvector = SNAPVEC
		coyoteTime = 0
		doubleJumpReady = false
	else:
		vel.y = vel.y + GRAVITY * delta
		snapvector = Vector2.ZERO
		coyoteTime += 1
		
	if Input.is_key_pressed(KEY_F10) or Input.is_action_just_pressed("select"):
		OS.window_fullscreen = !OS.window_fullscreen
		
	if Input.is_action_pressed("b"):
		if is_on_floor():
			speed = lerp(speed, MAXSPEED, .1)
	elif is_on_floor():
		speed = lerp(speed, STDSPEED, .1)
		
	if Input.is_action_pressed("right"):
		direction = 1
		if is_on_floor() and not attacking:
			$AnimationPlayer.play("Run")
			vel.x = speed
		else:
			vel.x = clamp(vel.x + AIR_STEER, 0, MAXSPEED)
		$char.scale.x = 1
		
	elif Input.is_action_pressed("left"):
		direction = -1
		if is_on_floor() and not attacking:
			$AnimationPlayer.play("Run")
			vel.x = speed * -1
		else:
			vel.x = clamp(vel.x - AIR_STEER, MAXSPEED * -1, 0)
		$char.scale.x = -1
		
	else:
		if is_on_floor() and not attacking:
			$AnimationPlayer.play("idle")
		if is_on_floor():
			vel.x = lerp(vel.x, 0, 0.8)
	
	if Input.is_action_just_pressed("a"):
		jumpBuffer = MAX_JUMP_BUFFER
		if doubleJumpReady:
			vel.y = JUMPFORCE
			doubleJumpReady = false
			varjump = true
			get_tree().create_timer(0.12).connect("timeout", self, '_varjump_timer_out')
		elif is_on_floor() or coyoteTime < MAX_COYOTE_TIME:
			jump()
	else:
		jumpBuffer -= 1
			
	if Input.is_action_pressed("a") and varjump:
		vel.y = vel.y - GRAVITY * delta
		
	if is_on_floor() and jumpBuffer > 0:
		jump()
	
	
	
	
	#measure jump heights
#	if is_on_floor() and !floored:
#		floored = true
#		inity = position.y
#		peak = position.y
#	if position.y < peak:
#		peak = position.y
#	print (inity - peak)
	
	vel = move_and_slide_with_snap(vel, snapvector, Vector2.UP, true)

func _varjump_timer_out():
	varjump = false
	
func attack():
	attacking = true
	$AnimationPlayer.play("Attack")
	yield(get_tree().create_timer(.2),"timeout")
	attacking = false
	var x = rng.randi_range(-500, -50)
	var y = rng.randi_range(-1800, -900)
	lost_sword(Vector2(x * direction, y))
	
func jump():
	$AnimationPlayer.play("jump")
	vel.y = JUMPFORCE
	doubleJumpReady = true
	varjump = true
	snapvector = Vector2.ZERO
	get_tree().create_timer(0.15).connect("timeout", self, '_varjump_timer_out')
	
func lost_sword(vel):
	has_sword = false
	emit_signal("lost_sword", position, vel)
	$char/body/Shoulder/arm/hand/sword.visible = false


func _on_Sword_picked_up_sword():
	$pickup.play()
	has_sword = true
	$char/body/Shoulder/arm/hand/sword.visible = true

func hit():
	if vulnerable:
		$AudioStreamPlayer2D.play()
		health -= 1
		vulnerable = false
		$coloranim.play("blink")
		if health < 1:
			die()
		
		yield(get_tree().create_timer(2), "timeout")
		vulnerable = true
		$coloranim.play("normal")

func die():
	get_tree().change_scene("res://die.tscn")
	
func _on_VisibilityNotifier2D_viewport_entered(viewport):
	canattack = true


func _on_Sword_sword_offscreen(offscreen, pos):
	pass # Replace with function body.
