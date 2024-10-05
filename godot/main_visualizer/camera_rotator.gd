extends Node3D

@onready var camera = $Camera3D

const SENSITIVITY = 0.003
var clickHeld : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _unhandled_input(event):
	if event is InputEventMouseMotion and clickHeld:
		self.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, -PI/2, PI/2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("LMB"):
		clickHeld = true
	if Input.is_action_just_released("LMB"):
		clickHeld = false
	pass
