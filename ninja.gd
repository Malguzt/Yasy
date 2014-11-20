extends KinematicBody2D

const GRAVITY = 600.0
const WALK_SPEED = 200
const JUMP_SPEED = 300.0
const DECELERATION = 5
const MAX_LIGHT = 100

var velocity = Vector2()
var canMove = false
var light = MAX_LIGHT

func _fixed_process(delta):
	light -= 0.1
	get_node("NinjaSprite").set_opacity(light/MAX_LIGHT)
	
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
	
	var motion = velocity * delta
	
	if(is_colliding()):
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

func _ready():
	set_fixed_process(true)

func play_animation(animation):
	var player = get_node("NinjaSprite").get_node("ninja_player")
	if(player and animation != player.get_current_animation()):
		player.play(animation)

func _on_Area2D_body_enter( body ):
	light = MAX_LIGHT
