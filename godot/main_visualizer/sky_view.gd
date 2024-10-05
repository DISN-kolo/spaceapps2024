extends Node3D

var file : FileAccess
var jsontxt : String
var data : Dictionary

var radius : float = 10

var starnode : PackedScene = preload("res://star_object_3d.tscn")
var instance
var instanceCoords : Vector3

var gloablSpectatorPos : Vector3 = Vector3(0, 0, 0)

func _ready() -> void:
	file = FileAccess.open("res://data/closest_5k_by_dist.txt", FileAccess.READ)
	jsontxt = file.get_as_text()
	data = JSON.parse_string(jsontxt)
	# data has the actual "data" key which in its value contains an array of arrays of floats.
	# these floats are: parallax, ra, dec and source_id (gaia dr3 thing)
	# RA is in deg (0..360)
	# DEC is in deg (should be -90..+90, right?)
	# so, to map, we need to take the canvas, divide it by the appropriate mix and max values of
	# ra and dec and then multiply it by the actual ra/dec.
	for coords in data["data"]:
		print(coords)
		instance = starnode.instantiate()
		# the last parameter being parallax is temporary (the higher the parallax,
		# the closer the star, the lesser the magnitude)
		instance._setup_star(gloablSpectatorPos,
			Vector3(coords[0], coords[1], coords[2]), radius, 1000/coords[0])
		add_child(instance)
		print("done!\n\n")



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		gloablSpectatorPos += Vector3(50, 0, 0)
		redraw()
	pass

func redraw() -> void:
	for childnode in get_children():
		if is_instance_valid(childnode) and childnode.is_in_group("star"):
			#print("just killed a node")
			childnode.queue_free()
	for coords in data["data"]:
		instance = starnode.instantiate()
		# the last parameter being parallax is temporary (the higher the parallax,
		# the closer the star, the lesser the magnitude)
		instance._setup_star(gloablSpectatorPos,
			Vector3(coords[0], coords[1], coords[2]), radius, 1000/coords[0])
		add_child(instance)
