extends KinematicBody2D

const GRAVITY = 600.0
const WALK_SPEED = 200
const JUMP_SPEED = 300.0
const DECELERATION = 5
const MAX_LIGHT = 100

var velocity = Vector2()
var canMove = false
var light = MAX_LIGHT
var last_window

func _fixed_process(delta):
	_check_light()
	velocity.y += delta * GRAVITY
	
	if(canMove):
		if(Input.is_action_pressed("ui_left") and canMove):
			velocity.x = -WALK_SPEED
		elif(Input.is_action_pressed("ui_right") and canMove):
			velocity.x = WALK_SPEED
		else:
			velocity.x = 0
	
	if(Input.is_action_pressed("ui_up") and canMove):
		velocity.y = -JUMP_SPEED
	
	if(velocity.x < -0.1):
		play_animation("run_left")
	elif(velocity.x > 0.1):
		play_animation("run_right")
	else:
		play_animation("wait")
		
	_check_collitions(delta)


func _check_collitions(delta):
	var motion = velocity * delta
	if(is_colliding()):
		_move_things()
		var normal = get_collision_normal()
		if(normal.dot(Vector2(0,-1)) >= -0.1):
			canMove = true
			motion = normal.slide(motion)
			velocity = normal.slide(velocity)
		else:
			velocity.y = delta * GRAVITY
	else:
		canMove = false
	move(motion)


func _move_things():
	if(get_collider().get_type() == "RigidBody2D"):
		var impulse = - get_collision_normal() * (velocity / 10) * (light / MAX_LIGHT)
		get_collider().apply_impulse(get_collision_pos(), impulse)


func _check_light():
	light -= 0.1
	if(light <= 0):
		set_pos(last_window.get_pos())
		light = MAX_LIGHT
	get_node("NinjaSprite").set_opacity(light/MAX_LIGHT)


func _ready():
	last_window = get_parent().get_node("Start")
	set_fixed_process(true)


func play_animation(animation):
	var player = get_node("NinjaSprite").get_node("ninja_player")
	if(player and animation != player.get_current_animation()):
		player.play(animation)


func take_light():
	light = MAX_LIGHT

func set_last_window(window):
	last_window = window
