extends CharacterBody3D

@export var movementSpeed = 10
@export var strafeSpeed = 7.5
@export var reverseSpeed = 5
@export var jumpSpeed = 6.5
@export var turnSpeed = 220
@export var fallAcceleration = 70
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _physics_process(delta):
	var movementDirection = Vector3()
	if Input.is_action_pressed("player_forwards"):
		movementDirection.x -= 1
	if Input.is_action_pressed("player_back"):
		movementDirection.x += 1
	if Input.is_action_pressed("player_left"):
		movementDirection.z += 1
	if Input.is_action_pressed("player_right"):
		movementDirection.z -= 1
	if Input.is_action_just_pressed("player_jump"):
		if is_on_floor():
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
		velocity.y -= gravity * delta
	#
	move_and_slide()
