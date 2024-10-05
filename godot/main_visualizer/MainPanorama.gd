extends Control

var file : FileAccess
var jsontxt : String
var data : Dictionary

var starnode : PackedScene = preload("res://star_object.tscn")
var instance
var instanceCoords : Vector2

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
		instanceCoords = Vector2(coords[1] * self.size.x / 360.0, (coords[2] + 90.0) * self.size.y / 180.0)
		instance.set_global_position(instanceCoords)
		instance.set_star_size(coords[0] / 1000.0)
		add_child(instance)
		
func _process(delta: float) -> void:
	pass
