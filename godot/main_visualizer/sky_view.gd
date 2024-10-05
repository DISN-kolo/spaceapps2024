extends Node3D

var file : FileAccess
var jsontxt : String
var data : Dictionary

var Gmagn : float
var Vmagn : float
var Gbp : float
var Grp : float

const MAG_LIMIT : float = 7.0

var radius : float = 10

var starnode : PackedScene = preload("res://star_object_3d.tscn")
var instance
var instanceCoords : Vector3

var gloablSpectatorPos : Vector3 = Vector3(0, 0, 0)

func _ready() -> void:
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
		if (first):
			print(coords)
			first = false
			instance.set_red()
		#print(coords)
		Gmagn = coords[0]
		Gbp = coords[1]
		Grp = coords[2]
		# https://astronomy.stackexchange.com/questions/48492/how-can-i-convert-a-gaia-magnitude-g-to-johnson-v
		Vmagn = Gmagn #+ 0.0176 + 0.00686*(Gbp - Grp) + 0.1732*(Gbp - Grp)**2
		if Vmagn > MAG_LIMIT:
			continue
		instance._setup_star(gloablSpectatorPos,
			Vector3(coords[3], coords[4], coords[5]), radius, Vmagn)
		add_child(instance)
		#print("done!\n\n")



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		gloablSpectatorPos += Vector3(10, 0, 0)
		redraw()
	if Input.is_action_just_pressed("ui_cancel"):
		gloablSpectatorPos = Vector3(0, 0, 0)
		redraw()

func redraw() -> void:
	for childnode in get_children():
		if is_instance_valid(childnode) and childnode.is_in_group("star"):
			#print("just killed a node")
			childnode.queue_free()
	for coords in data["data"]:
		instance = starnode.instantiate()
		Gmagn = coords[0]
		Gbp = coords[1]
		Grp = coords[2]
		Vmagn = Gmagn #+ 0.0176 + 0.00686*(Gbp - Grp) + 0.1732*(Gbp - Grp)**2
		if Vmagn > MAG_LIMIT:
			continue
		instance._setup_star(gloablSpectatorPos,
			Vector3(coords[3], coords[4], coords[5]), radius, Vmagn)
		add_child(instance)
