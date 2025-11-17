extends CharacterBody3D

# How fast the player moves in meters per second.
@export var speed = 7
# The downward acceleration when in the air, in meters per second squared.
@export var fall_acceleration = 75

@onready var body: Node3D = $cat00
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var target_velocity = Vector3.ZERO

func _physics_process(delta):
	# We create a local variable to store the input direction.
	var direction = Vector3.ZERO

	# We check for each move input and update the direction accordingly.
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_down"):
		direction.z += 1
	if Input.is_action_pressed("ui_up"):
		direction.z -= 1
	
	# Normalize the direction to avoid faster diagonal movement.
	if direction != Vector3.ZERO:
		direction = direction.normalized()
	
	# Ground Velocity
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed

	# Vertical Velocity
	if not is_on_floor(): # If in the air, fall towards the floor. Literally gravity
		target_velocity.y = target_velocity.y - (fall_acceleration * delta)

	# Rotate the body to face the movement direction
	if direction != Vector3.ZERO: # Only rotate if there's movement
		var look_direction = Vector3(direction.x, 0, direction.z)
		body.look_at(body.global_transform.origin + look_direction, Vector3.UP, true)

		# Play the walk animation if not already playing
		if not animation_player.is_playing() or animation_player.current_animation != "walk":
			animation_player.play("walk1")
	else:
		# Stop the animation if there is no movement
		if animation_player.is_playing() and animation_player.current_animation == "walk":
			animation_player.stop()

	# Moving the Character
	velocity = target_velocity
	move_and_slide()
