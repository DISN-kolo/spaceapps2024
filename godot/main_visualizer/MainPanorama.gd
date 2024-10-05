extends Control

var file : FileAccess
var jsontxt : String
var data : Dictionary

var starnode : PackedScene = preload("res://star_object.tscn")
var instance
var instanceCoords : Vector2

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
		instance = starnode.instantiate()
		instance.setup_star(gloablSpectatorPos, Vector3(coords[0], coords[1], coords[2]), self.size)
		add_child(instance)
	
func _process(delta: float) -> void:
	if Input.is_action_pressed("ui_accept"):
		pass # nothing for now
		#gloablSpectatorPos += Vector3(5, 0, 0)
		#gloablSpectatorPos = capGSP(gloablSpectatorPos)
		#redraw()

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

#func redraw() -> void:
	#var ctr : int = 0
	#for childnode in get_children():
		#ctr += 1
		#if is_instance_valid(childnode):
			##print("just killed a node")
			#childnode.queue_free()
	#print("there were ", ctr, " nodes")
	#for coords in data["data"]:
		#instance = starnode.instantiate()
		#instance.setup_star(gloablSpectatorPos, Vector3(coords[0], coords[1], coords[2]), self.size)
		#add_child(instance)
