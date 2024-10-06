extends Control

var file : FileAccess
var jsontxt : String
var data : Dictionary

var starnode : PackedScene = preload("res://star_object.tscn")
var instance
var instancesarr : Array
var instanceCoords : Vector2

var gloablSpectatorPos : Vector3 = Vector3(0, 0, 0)

var Gmagn : float
var Gbp : float
var Grp : float
var Vmagn : float

var clickHeld : bool = false

var sensitivity : float = 0.001

const MAG_LIMIT : float = 8.0

var planetIndex : int = 0 # 0 is earth, 1 is Gliese 876, 2 is Proxima Centauri
var planetNames : Array = ["Earth", "Gliese 876", "Proxima Centauri"]
var exoCoords : Array = [Vector3(0,0,0), Vector3(768, 217.4292, -62.6794), Vector3(214, 343.3208, -14.2636)]
#var exoCoords : Array = [Vector3(0,0,0), Vector3(740, 217.4292, -62.6794), Vector3(200, 343.3208, -14.2636)]

func _ready() -> void:
	$RichTextLabel.text = planetNames[planetIndex]
	file = FileAccess.open("res://data/brightest_5k_by_g_magn.txt", FileAccess.READ)
	jsontxt = file.get_as_text()
	data = JSON.parse_string(jsontxt)
	# data has the actual "data" key which in its value contains an array of arrays of floats.
	# these floats are: parallax, ra, dec and source_id (gaia dr3 thing)
	# RA is in deg (0..360)
	# DEC is in deg (should be -90..+90, right?)
	# so, to map, we need to take the canvas, divide it by the appropriate mix and max values of
	# ra and dec and then multiply it by the actual ra/dec.
	var first : bool = true
	for coords in data["data"]:
		instance = starnode.instantiate()
		instancesarr.append(instance)
		if (first):
			print(coords)
			first = false
			#instance.set_star_color(Color(1, 0, 0, 1))
		#print(coords)
		Gmagn = coords[0]
		Gbp = coords[1]
		Grp = coords[2]
		# https://astronomy.stackexchange.com/questions/48492/how-can-i-convert-a-gaia-magnitude-g-to-johnson-v
		Vmagn = Gmagn #+ 0.0176 + 0.00686*(Gbp - Grp) + 0.1732*(Gbp - Grp)**2
		#print(Vmagn)
		if Vmagn > MAG_LIMIT:
			continue
		instance.setup_star(gloablSpectatorPos, Vector3(coords[3], coords[4], coords[5]), self.size, Vmagn*1.2, coords[6], Vector3(0, 0, 0), false)
		add_child(instance)
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		planetIndex = (planetIndex + 1) % 3
		$RichTextLabel.text = planetNames[planetIndex]
		redraw(planetIndex)
	if Input.is_action_just_pressed("RMB"):
		print(planetIndex)
		clickHeld = true
		for star in get_children():
			if star.is_in_group("star"):
				star.x_shift(star.global_position.x - size.x / 2 + get_global_mouse_position().x)
		#redraw(get_global_mouse_position().x / size.x * 360 - 180)
		
	if Input.is_action_just_released("RMB"):
		clickHeld = false

#func capGSP(gsp: Vector3) -> Vector3:
	#if gsp.x < 0:
		#gsp.x = 0
	## with RA, we wanna "scroll thru"
	#if gsp.y < 0 or gsp.y > 360:
		#gsp.y -= floor(gsp.y/360) * 360
	## with DEC, we want a hard cap, since it's in the caps
	#if gsp.z < -90:
		#gsp.z = -90
	#if gsp.z > 90:
		#gsp.z = 90
	#return (gsp)

func redraw(idx : int) -> void:
	var ctr : int = 0
	for childnode in get_children():
		if childnode.is_in_group("star"):
			ctr += 1
			if is_instance_valid(childnode):
				#print("just killed a node")
				remove_child(childnode)
				childnode.queue_free()
	while (len(instancesarr) > 0):
		instancesarr[0].queue_free()
		instancesarr.pop_front()
	#print("there were ", ctr, " nodes")
	var first : bool = true
	for coords in data["data"]:
		instance = starnode.instantiate()
		instancesarr.append(instance)
		if (first):
			print(coords)
			first = false
			#instance.set_star_color(Color(1, 0, 0, 1))
		#print(coords)
		Gmagn = coords[0]
		Gbp = coords[1]
		Grp = coords[2]
		# https://astronomy.stackexchange.com/questions/48492/how-can-i-convert-a-gaia-magnitude-g-to-johnson-v
		Vmagn = Gmagn #+ 0.0176 + 0.00686*(Gbp - Grp) + 0.1732*(Gbp - Grp)**2
		#print(Vmagn)
		if Vmagn > MAG_LIMIT:
			continue
		#coords[4] = coords[4] - shift_ra - floor((coords[4] - shift_ra) / 360) * 360
		if idx != 0:
			instance.setup_star(gloablSpectatorPos, Vector3(coords[3], coords[4], coords[5]), self.size, Vmagn, coords[6], exoCoords[idx], true)
		else:
			instance.setup_star(gloablSpectatorPos, Vector3(coords[3], coords[4], coords[5]), self.size, Vmagn, coords[6], Vector3(0,0,0), false)
		add_child(instance)
