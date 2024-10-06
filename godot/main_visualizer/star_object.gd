extends Control

var instanceCoords : Vector2
var newCoords : Vector3

const LOG10 : float = 2.302585

var newMagn : float
var brightness : float

var winsizeSaved : Vector2

var xposition_target : float

var done_moving : bool = true

var starid : int

var mouseinside : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.set_global_position(instanceCoords)
	xposition_target = get_global_position().x
	$RichTextLabel.text = "star id is " + str(starid) + \
	#"\nx:   " + str(instanceCoords[0]) + \
	#"\ny:   " + str(instanceCoords[1]) + \
	"\nra:  " + str(newCoords[1]) + \
	"\ndec: " + str(newCoords[2])
	$RichTextLabel.visible = false
	$RichTextLabel.scale = Vector2(1, 1) / self.scale
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("LMB") and done_moving and mouseinside:
		$RichTextLabel.visible = true
	if Input.is_action_just_pressed("LMB") and not mouseinside:
		$RichTextLabel.visible = false
	
	if abs(xposition_target - self.global_position.x) > 1 and not done_moving:
		self.global_position.x = lerp(self.global_position.x, xposition_target, 0.7)
	else:
		self.global_position.x = xposition_target
		done_moving = true
	if done_moving and (self.global_position.x > winsizeSaved.x or self.global_position.x < 0):
		self.global_position.x = self.global_position.x - winsizeSaved.x * floor (self.global_position.x / winsizeSaved.x)

func	set_star_size(sizes: float) -> void:
	self.scale = Vector2(sizes, sizes)

func setup_star(pov: Vector3, relativeCoords: Vector3, windowSize: Vector2, magnitude: float, sid: int,
newpov : Vector3, usenewpov : bool) -> void:
	starid = sid
	if (usenewpov):
		newCoords = calculate_relative_coords(calculate_absolute_coords(relativeCoords) - calculate_absolute_coords(newpov))
		newMagn = magnitude + 5 - 5 * log ((10e3 / relativeCoords.x )**2)/LOG10 # absoulte
		newMagn = newMagn - 5 + 5 * log ((10e3 / newCoords.x )**2)/LOG10
	elif (abs(pov.x) > 0.0001 or abs(pov.y) > 0.0001 or abs(pov.z) > 0.0001):
		newCoords = calculate_relative_coords(calculate_absolute_coords(relativeCoords) + pov)
		newMagn = magnitude + 5 - 5 * log ((10e3 / relativeCoords.x )**2)/LOG10 # absoulte
		newMagn = newMagn - 5 + 5 * log ((10e3 / newCoords.x )**2)/LOG10 # extract relative 5from the formula, and pass on new coords and values
	else:
		newCoords = relativeCoords
		newMagn = magnitude
	instanceCoords = Vector2((360.0 - newCoords[1]) * windowSize.x / 360.0, (-newCoords[2] + 90.0) * windowSize.y / 180.0)
	instanceCoords.x = instanceCoords.x - floor(instanceCoords.x / windowSize.x) * windowSize.x
	instanceCoords.y = instanceCoords.y - floor(instanceCoords.y / windowSize.y) * windowSize.y
	brightness = 10 ** (newMagn / (-2.5))
	if brightness > 5:
		brightness = 5
	set_star_size(sqrt(brightness))
	winsizeSaved = windowSize

# https://math.libretexts.org/Courses/Monroe_Community_College/MTH_212_Calculus_III/Chapter_11%3A_Vectors_and_the_Geometry_of_Space/11.7%3A_Cylindrical_and_Spherical_Coordinates
func calculate_absolute_coords(inp: Vector3) -> Vector3:
	var p : float = 10e3 / inp.x # parallax is in mas, thus p in aus is 1/parallax = 10e3/[mas]
	var ra : float = inp.y
	var dec : float = inp.z
	
	var x : float
	var y : float
	var z : float
	
	x = p * sin(deg_to_rad(90 - dec)) * cos(deg_to_rad(ra))
	y = p * cos(deg_to_rad(90 - dec))
	z = p * sin(deg_to_rad(90 - dec)) * sin(deg_to_rad(ra))
	#print(x, " ", y, " ", z)
	return (Vector3(x, y, z))

func calculate_relative_coords(inp: Vector3) -> Vector3:
	var x : float = inp.x
	var y : float = inp.y
	var z : float = inp.z
	
	var p : float
	var ra : float
	var dec : float
	
	p = sqrt(x**2 + y**2 + z**2)
	ra = rad_to_deg(atan(z/x))
	if (x < 0):
		#if (z < 0):
		ra += 180
	elif (z < 0):
		ra += 360
	dec = rad_to_deg(asin(y/p))
	#print(y/p, " ", ra, " ", dec)
	p = 10e3 / p
	return (Vector3(p, ra, dec))

func set_star_color(c: Color) -> void:
	$Sprite2D.modulate = c

var tween_shift : Tween
func x_shift(s: float) -> void:
	done_moving = false
	xposition_target = s
	#if tween_shift and not tween_shift.is_running():
		#tween_shift.kill()
	#if tween_shift and tween_shift.is_running():
		#return
		##tween_shift.pause()
		##tween_shift.custom_step(1.0)
		##tween_shift.kill()
	#tween_shift = create_tween()
	#tween_shift.tween_property(self, "global_position", Vector2(s, global_position.y), 2)

	#if not (tween_shift and tween_shift.is_running()):
		#tween_shift = create_tween()
	#
	


func _on_mouse_entered() -> void:
	#print("hello! you've entered star ", starid)
	mouseinside = true
	pass # Replace with function body.


func _on_mouse_exited() -> void:
	mouseinside = false
	pass # Replace with function body.
