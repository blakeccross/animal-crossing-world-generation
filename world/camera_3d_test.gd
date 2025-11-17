extends Camera3D

# Sensitivity and speed settings
var mouse_sensitivity: float = 0.2
var move_speed: float = 10.0
var boost_multiplier: float = 3.0

# Rotation variables
var rotation_x: float = 0.0
var rotation_y: float = 0.0

func _ready():
	# Capture the mouse for freelook
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta: float):
	handle_mouse_look(delta)
	handle_movement(delta)

func handle_mouse_look(delta: float):
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		var mouse_delta = Input.get_last_mouse_velocity() * mouse_sensitivity * delta
		
		# Adjust yaw (left-right) and pitch (up-down)
		rotation_y -= mouse_delta.x
		rotation_x -= mouse_delta.y
		
		# Clamp pitch to avoid flipping the camera
		rotation_x = clamp(rotation_x, -89.0, 89.0)
		
		# Apply rotation to the camera
		rotation_degrees = Vector3(rotation_x, rotation_y, 0)

func handle_movement(delta: float):
	# Get input for movement
	var direction = Vector3()
	
	if Input.is_action_pressed("ui_up"): # W
		direction -= transform.basis.z
	if Input.is_action_pressed("ui_down"): # S
		direction += transform.basis.z
	if Input.is_action_pressed("ui_left"): # A
		direction -= transform.basis.x
	if Input.is_action_pressed("ui_right"): # D
		direction += transform.basis.x
	if Input.is_action_pressed("ui_page_up"): # E
		direction += transform.basis.y
	if Input.is_action_pressed("ui_page_down"): # Q
		direction -= transform.basis.y

	# Apply movement speed and boost
	if Input.is_action_pressed("ui_accept"): # Shift for boost
		direction *= move_speed * boost_multiplier
	else:
		direction *= move_speed

	# Move the camera
	if direction != Vector3.ZERO:
		transform.origin += direction * delta

func _input(event):
	# Toggle mouse capture mode with Esc
	if event is InputEventKey and event.pressed and event.as_text() == "Escape":
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
