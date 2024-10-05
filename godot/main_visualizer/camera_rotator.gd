extends Node3D

@onready var camera = $Camera3D

const SENSITIVITY_DEFAULT = 0.0025
var sensitivity : float = SENSITIVITY_DEFAULT
var clickHeld : bool = false

var desiredFov : float = 90
const FOV_MIN = 10.0
const FOV_MAX = 90.0
const ZOOM_FACTOR = 1.1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _unhandled_input(event):
	if event is InputEventMouseMotion and clickHeld:
		self.rotate_y(event.relative.x * sensitivity)
		camera.rotate_x(event.relative.y * sensitivity)
		camera.rotation.x = clamp(camera.rotation.x, -PI/2, PI/2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("LMB"):
		clickHeld = true
	if Input.is_action_just_released("LMB"):
		clickHeld = false
		
	if Input.is_action_just_pressed("zoom_in"):
		desiredFov /= ZOOM_FACTOR
	elif Input.is_action_just_pressed("zoom_out"):
		desiredFov *= ZOOM_FACTOR
	desiredFov = clamp(desiredFov, FOV_MIN, FOV_MAX)
	sensitivity = desiredFov / FOV_MAX * SENSITIVITY_DEFAULT
	camera.set_fov(desiredFov)
