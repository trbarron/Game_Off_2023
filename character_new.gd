extends CharacterBody3D

const FRICTION = 0.999
const HORIZONTAL_ACCELERATION = 2.3

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var rollingDirection = Vector3.ZERO

var countdown = 3
var startAction = false
var time = 0

@onready var cameraNode = get_node("../character/Camera3D")
@onready var countdownLabel = $CountdownLabel
@onready var countdownTimer = $CountdownTimer
@onready var sphereMesh = $CSGMesh3D
@onready var postScoreRequest = $postScoreHTTPRequest

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	var deathArea = get_node("../DeathArea")
	deathArea.connect("character_died", Callable(self, "_on_character_died"))
	
	# Initialize the countdown
	countdownTimer.connect("timeout", Callable(self, "_on_CountdownTimer_timeout"))
	start_countdown()
	
	var goalArea = get_node("../GoalArea")
	goalArea.connect("character_won", Callable(self, "_on_character_won"))


func start_countdown():
	countdown = 3
	countdownLabel.text = str(countdown)
	countdownTimer.start()
	set_process(false)  # Disable other processes during countdown

func _on_CountdownTimer_timeout():
	countdown -= 1
	if countdown > 0:
		countdownLabel.text = str(countdown)
	else:
		countdownLabel.text = ""
		countdownTimer.stop()
		set_process(true)
		startAction = true

func _on_character_died():
	startAction = false

func _on_character_won():
	startAction = false
	
	# Define the base URL without query parameters
	var base_url = "https://qse3b041vg.execute-api.us-west-2.amazonaws.com/stage1/sz/postScore"


	var current_scene_name = get_tree().current_scene.name
	var currStageName = current_scene_name.split("-")[1]
	
	
	# Define the query parameters as a Dictionary
	var query_parameters = {
		"stage": currStageName,
		"time": round(time * 1000),
		"name": Globals.globalUsername
	}

	# Convert the query_parameters Dictionary into a query string
	var query_string = "?"
	for key in query_parameters:
		query_string += key + "=" + str(query_parameters[key]) + "&"

	# Remove the trailing "&" from the query string
	query_string = query_string.substr(0, query_string.length() - 1)

	# Construct the final URL with query parameters
	var final_url = base_url + query_string
	
	print(final_url)
	
	# Prepare the HTTP request
	postScoreRequest.request(
		final_url,
		[],  # Custom headers (if any)
		false,  # Use ssl (true for https)
		"POST"
	)

# Callback when request is completed
# Callback when request is completed
func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	var parser = JSON.new()
	var response = parser.parse(body.get_string_from_utf8())
	if response.error == OK:
		print("Response: ", response.result)
	else:
		print("Error parsing JSON")

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		follow_cursor(event.position)

# Continuously update rolling direction based on mouse position
func follow_cursor(mousePos):
	var rayFrom = cameraNode.project_ray_origin(mousePos)
	var rayDir = cameraNode.project_ray_normal(mousePos)
	var plane = Plane(Vector3(0, 1, 0), 0)
	var intersect = plane.intersects_ray(rayFrom, rayDir)

	if intersect:
		var dir = intersect - global_transform.origin
		dir.y = 0
		rollingDirection = dir.normalized()

func _physics_process(delta):
	if startAction:
		if not is_on_floor():
			velocity.y -= gravity * delta

		if rollingDirection != Vector3.ZERO:
			var force = rollingDirection * HORIZONTAL_ACCELERATION
			velocity += force * delta

		# velocity.x *= FRICTION
		# velocity.z *= FRICTION

		var horizontalSpeed = Vector2(velocity.x, velocity.z)
		
		time += delta
		countdownLabel.text = str(round(time * 100.0) / 100.0)

		move_and_slide()
		
		# Calculate the rotation angle
		var distance = velocity.length() * delta
		const sphereRadius = 0.5
		var rotation_angle = distance / sphereRadius

		# Determine the axis of rotation
		var rotation_axis = Vector3(velocity.x, -velocity.z, 0).normalized()  # Adjusted axis
		if rotation_axis.length() != 0:  # Check to avoid NaN errors
			sphereMesh.rotate_object_local(rotation_axis, rotation_angle)

