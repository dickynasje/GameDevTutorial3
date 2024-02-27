extends KinematicBody2D

export (int) var speed = 400
export (int) var dashingSpeed = 4000
export (int) var GRAVITY = 1200
export (int) var jumpPower = -600
export (int) var doubleJumpCounter = 1
onready var animation = $AnimationPlayer
onready var sprite = $Sprite

const UP = Vector2(0,-1)
var velocity = Vector2()
var direction = Vector2.ZERO
func get_input():
	velocity.x = 0
	#Basic movement and double jump
	if Input.is_action_just_pressed("ui_up") and !Input.is_action_pressed("ui_down"):
		if doubleJumpCounter > 0 :
			velocity.y = jumpPower
			doubleJumpCounter -= 1
		
	if Input.is_action_pressed("ui_right"):
		sprite.flip_h = false
		animation.play("Walk")
		direction.x = 1
		
		if !is_on_floor():
			animation.play("Jump")
		
		if Input.is_action_pressed("ui_down"):
			velocity.x += (speed * 0.2)
		else:
			velocity.x += speed
		
	if Input.is_action_pressed("ui_left"):
		sprite.flip_h = true
		animation.play("Walk")
		direction.x = -1
		
		if !is_on_floor():
			animation.play("Jump")
			
		if Input.is_action_pressed("ui_down"):
			velocity.x -= (speed * 0.2)
		else:
			velocity.x -= speed
		
	if Input.is_action_just_released("ui_left") and is_on_floor():
		animation.play("Idle")
		
	if Input.is_action_just_released("ui_right") and is_on_floor():
		animation.play("Idle")
		
	if !is_on_floor():
		animation.play("Jump")
		
	if is_on_floor() and animation.get_current_animation() == "Jump":
		animation.play("Idle")
	
	if is_on_floor():
			doubleJumpCounter = 1
			
	if Input.is_action_pressed("ui_left") and Input.is_action_pressed("ui_right"):
		animation.play("Idle")
		
	if Input.is_action_pressed("ui_down"):
		animation.stop(true)
		sprite.set_frame(3)
		
	if Input.is_action_just_released("ui_down"):
		animation.play("Idle")



func _physics_process(delta):
	print(doubleJumpCounter)
	velocity.y += delta * GRAVITY
	get_input()
	velocity = move_and_slide(velocity, UP)
