extends CharacterBody3D

var walkAnimation: AnimationPlayer

func _ready():
	walkAnimation = get_node("penguinscene/AnimationPlayer")
	walkAnimation.get_animation("walk_cycle_on_Egg").loop = true

func animateForwards():
	if not walkAnimation.is_animation_active():
		if walkAnimation.current_animation == "walk_cycle_on_Egg":
			walkAnimation.play()
		else:
			walkAnimation.clear_queue()
			walkAnimation.current_animation = "walk_cycle_on_Egg"
			walkAnimation.play()
	else:
		if not walkAnimation.current_animation == "walk_cycle_on_Egg":
			walkAnimation.stop()
			walkAnimation.clear_queue()
			walkAnimation.current_animation = "walk_cycle_on_Egg"
			walkAnimation.play()

func stopWalkAnimation():
	walkAnimation.stop()
			

@export var movementSpeed = 1
@export var strafeSpeed = 0.75
@export var reverseSpeed = 0.5
@export var jumpSpeed = 1500
@export var turnSpeed = 235
@export var fallAcceleration = 3000
var jumpTimeBuffer = 0
var jumpTimeBufferLimit = 0.14
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _physics_process(delta):
	if is_on_floor():
		jumpTimeBuffer = jumpTimeBufferLimit
	else:
		jumpTimeBuffer -= delta
	var movementDirection = Vector3()
	if Input.is_action_pressed("player_forwards"):
		animateForwards()
		movementDirection.z += 1
	else:
		stopWalkAnimation()
	if Input.is_action_pressed("player_back"):
		movementDirection.z -= 1
	if Input.is_action_pressed("player_left"):
		movementDirection.x += 1
	if Input.is_action_pressed("player_right"):
		movementDirection.x -= 1
	if Input.is_action_just_pressed("player_jump"):
		if is_on_floor() || jumpTimeBuffer > 0:
			velocity.y += jumpSpeed
	if Input.is_action_pressed("player_turn_left"):
		rotation_degrees.y += turnSpeed * delta
	if Input.is_action_pressed("player_turn_right"):
		rotation_degrees.y -= turnSpeed * delta
	
	movementDirection = movementDirection.normalized()
	movementDirection = global_basis * movementDirection
	velocity.z = movementDirection.z * strafeSpeed
	if movementDirection.x < 0:
		velocity.x = movementDirection.x * reverseSpeed
	else:
		velocity.x = movementDirection.x * movementSpeed
			
	if not is_on_floor():
		velocity.y -= fallAcceleration * delta
	#
	move_and_slide()
