extends CharacterBody3D

const FRICTION = 0.995
const HORIZONTAL_ACCELERATION = 140
const MAX_SPEED = 500
const VEL_VECTOR_SCALAR = 3

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var rollingDirection = Vector3.ZERO

var savedVelocity = Vector3.ZERO

var timeActive = false
var timeActiveOS = false
var turns = 0

var isInactive = false

@onready var dirArrow = $directionArrow
@onready var velArrow = $velocityArrow
@onready var cameraNode = get_node("/root/1-1/character/Camera3D")
@onready var turnLabel = get_node("/root/1-1/TimerLabel/SubViewportContainer/SubViewport/Timer")
@onready var stopToStartTimer = $StopToStartTimer
@onready var startToStopTimer = $StartToStopTimer

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	var deathArea = get_node("/root/1-1/DeathArea")
	deathArea.connect("character_died", Callable(self, "_on_character_died"))
	updateVelocityArrowDirection()


func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed and !timeActive:
			follow_cursor(event.position)
			startTime()

	if event is InputEventMouseMotion:
		var mousePos = event.position
		var rayFrom = cameraNode.project_ray_origin(mousePos)
		var rayDir = cameraNode.project_ray_normal(mousePos)

		var plane = Plane(Vector3(0, 1, 0), 0)  # Create a horizontal plane at y=0
		var intersect = plane.intersects_ray(rayFrom, rayDir)
		
		if intersect:
			var dir = intersect - global_transform.origin
			dir.y = 0  # Keep movement on the ground plane
			dir = dir.rotated(Vector3(0, 1, 0), deg_to_rad(90))
			dirArrow.look_at(dirArrow.global_transform.origin + dir, Vector3(0, 1, 0))
			if !timeActive: dirArrow.visible = true  # Make arrow visible

func stopTime():
	timeActive = false
	savedVelocity = velocity
	velocity = Vector3.ZERO
	turns += 1

	velArrow.visible = true  # Make velocity arrow visible
	updateVelocityArrowDirection()  # Update the arrow to point in the direction of savedVelocity
	updateTurnDisplay()

	stopToStartTimer.start()

func startTime():
	timeActive = true
	timeActiveOS = true
	velocity = savedVelocity

	dirArrow.visible = false  # Hide the direction arrow
	velArrow.visible = false  # Hide the velocity arrow as well

	startToStopTimer.start()


func updateVelocityArrowDirection():
	if savedVelocity.length() == 0 or savedVelocity.length() > 8:
		velArrow.scale = Vector3(0,0,0)
	else:
		var direction = savedVelocity.normalized()
		# Rotate the direction by 90 degrees around the Y-axis
		direction = direction.rotated(Vector3(0, 1, 0), deg_to_rad(90))
		velArrow.look_at(global_transform.origin + direction, Vector3.UP)
		
		# Scale the arrow proportionally to the velocity magnitude
		var scale_factor = savedVelocity.length() / VEL_VECTOR_SCALAR
		velArrow.scale = Vector3(scale_factor, scale_factor, scale_factor)

# This function is now separated from the input event
func follow_cursor(mousePos):
	var rayFrom = cameraNode.project_ray_origin(mousePos)
	var rayDir = cameraNode.project_ray_normal(mousePos)

	var plane = Plane(Vector3(0, 1, 0), 0)  # Create a horizontal plane at y=0
	var intersect = plane.intersects_ray(rayFrom, rayDir)
	
	if intersect:
		var dir = intersect - global_transform.origin
		dir.y = 0  # Keep movement on the ground plane
		rollingDirection = dir.normalized()

func _physics_process(delta):
	if timeActive:
		if not is_on_floor():
			velocity.y -= gravity * delta

		if rollingDirection != Vector3.ZERO and timeActiveOS:
			timeActiveOS = false
			rollingDirection = rollingDirection.normalized()
			var force = rollingDirection * HORIZONTAL_ACCELERATION
			velocity += force * delta

		velocity.x *= FRICTION
		velocity.z *= FRICTION

		var horizontalSpeed = Vector2(velocity.x, velocity.z)

		if horizontalSpeed.length() > MAX_SPEED:
			horizontalSpeed = horizontalSpeed.normalized() * MAX_SPEED
			velocity.x = horizontalSpeed.x
			velocity.z = horizontalSpeed.y

		move_and_slide()

func _on_stop_to_start_timer_timeout():
	pass

func _on_start_to_stop_timer_timeout():
	stopTime()

func _on_character_died():
	print("_on_char_died")
	dirArrow.visible = false
	velArrow.visible = false
	
func updateTurnDisplay():
	turnLabel.text = "Turns: " + str(turns)
	

