extends Camera3D

var target: CharacterBody3D  # The target to follow
var cameraDistance: float = 6.0
var cameraHeight: float = 6.0
var cameraAngle: float = 45.0
var rotationSpeed: float = 90.0  # Degrees per second
var lerpSpeed: float = 4.0  # Control how fast the camera moves to the new position

func _ready():
	target = get_node("../../character")  # Adjust the path as necessary

func _process(delta: float) -> void:
	if target:
		# Calculate the position behind the target based on the angle
		var offset = Vector3.BACK.rotated(Vector3.UP, deg_to_rad(cameraAngle)) * cameraDistance
		offset.y += cameraHeight
		var desiredPosition = target.global_transform.origin + offset

		# Smoothly interpolate the camera's position
		global_transform.origin = global_transform.origin.lerp(desiredPosition, lerpSpeed * delta)
		look_at(target.global_transform.origin, Vector3.UP)
		handle_input(delta)

func handle_input(delta):
	if Input.is_key_pressed(KEY_A):  # Check if 'A' is pressed
		rotate_left(delta)
	if Input.is_key_pressed(KEY_S):  # Check if 'S' is pressed
		rotate_right(delta)

func rotate_left(delta):
	cameraAngle -= rotationSpeed * delta  # Adjust the angle as needed
	if cameraAngle < 0:
		cameraAngle += 360

func rotate_right(delta):
	cameraAngle += rotationSpeed * delta  # Adjust the angle as needed
	if cameraAngle >= 360:
		cameraAngle -= 360
