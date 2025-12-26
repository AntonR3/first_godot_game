extends Node3D

@onready var floor_tile = preload("res://map_tile.tscn")

var active_tile = null

func _ready() -> void:
	var first_tile = floor_tile.instantiate()
	%tiles.add_child(first_tile)
	first_tile.global_position = Vector3(0,-20,0)
	first_tile.createStreet("center")
	#first_tile.player_entered.connect(_on_player_entered)
	active_tile = first_tile
	
	var positions = [
		Vector3(0, -20, -20),	# nord
		Vector3(20, -20, 0),	# ost
		Vector3(0, -20, 20),	# süd
		Vector3(-20, -20, 0)	# west
	]
	var directions = ["north", "east", "south", "west"]

	for pos in positions:
		var box = floor_tile.instantiate()
		%tiles.add_child(box)
		box.global_position = pos
		box.player_entered.connect(_on_player_entered)
		box.createStreet(directions[positions.find(pos)])
		
func _on_player_entered(box: Node3D):
	call_deferred("_process_player_entered", box)

func _process_player_entered(box: Node3D):
	var children = []
	for child in %tiles.get_children():
		if child != active_tile and child != box:
			children.append(child)
	
	active_tile = box
	
	var distance = box.global_position - $spieler.global_position
	var direction 

	if abs(distance.x) > abs(distance.z):
		direction = "east" if distance.x >= 0 else "west"
	else:
		direction = "south" if distance.z >= 0 else "north"

	createNewTiles(direction, box.global_position)
	for child in children:
		child.queue_free()



	
func createNewTiles(direction: String, coord: Vector3):
	print("entered from: ",direction)
	var coords = [
		Vector3(coord.x, -20, coord.z-20),	# north
		Vector3(coord.x+20, -20, coord.z),	# east
		Vector3(coord.x, -20, coord.z+20),	# south
		Vector3(coord.x-20, -20, coord.z)	# west
	]
	var directions = ["north", "east", "south", "west"]
	match direction:
		"north":
			coords.pop_at(2)
			directions.pop_at(2)
		"east":
			coords.pop_at(3)
			directions.pop_at(3)
		"south":
			coords.pop_at(0)
			directions.pop_at(0)
		"west":
			coords.pop_at(1)
			directions.pop_at(1)

	for pos in coords:
		var box = floor_tile.instantiate()
		box.player_entered.connect(_on_player_entered)
		%tiles.add_child(box)
		box.global_position = pos
		box.createStreet(directions[coords.find(pos)])
