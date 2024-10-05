extends Node3D

var newCoords : Vector3
var newMagn : float
var tempCoords : Vector3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_global_position(tempCoords)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func	set_star_size(size: float) -> void:
	self.scale = Vector3(size, size, 1.0)

# keep in mind: unless specified otherwise, the magnitude of a star is the relative
# magnitude as seen from earth
#
# https://www.phys.ksu.edu/personal/wysin/astro/magnitudes.html
func _setup_star(pov: Vector3, relativeCoords: Vector3, radius: float, magnitude: float) -> void:
	if (abs(pov.x) > 0.0001 or abs(pov.y) > 0.0001 or abs(pov.z) > 0.0001):
		newCoords = calculate_relative_coords(calculate_absolute_coords(relativeCoords) + pov)
		newMagn = magnitude - 2.5 * log ((10e2 / relativeCoords.x ) ** 2) # absoulte (fyi there was a /10 but i shortened the e3 to e2 instead)
		newMagn = - newMagn + 2.5 * log ((10e2 / newCoords.x ) ** 2) # extract relative from the formula, and pass on new coords and values
	else:
		newCoords = relativeCoords
		newCoords.x = 10e3 / newCoords.x
		newMagn = magnitude
	tempCoords = sphere_project(newCoords, radius)
	set_star_size(1 / newMagn)

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
	print(y/p, " ", ra, " ", dec)
	p = 10e3 / p
	return (Vector3(p, ra, dec))

func sphere_project(inp: Vector3, radius: float) -> Vector3:
	#var p : float = inp.x
	var p : float = radius
	var ra : float = inp.y
	var dec : float = inp.z
	
	var x : float
	var y : float
	var z : float
	
	x = p * sin(deg_to_rad(90 - dec)) * cos(deg_to_rad(ra))
	y = p * sin(deg_to_rad(90 - dec)) * sin(deg_to_rad(ra))
	z = p * cos(deg_to_rad(90 - dec))
	return (Vector3(x, y, z))
