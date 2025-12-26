extends Node3D

signal player_entered(box: Node3D)

var mat = StandardMaterial3D.new()

var wall_mat = StandardMaterial3D.new()

func _ready():
	randomize()
	# Triplanar-UV aktivieren
	mat.uv1_triplanar = true
	# Textur setzen (Pfad anpassen!)
	mat.albedo_texture = load("res://floor_texture.png")
	# Zufällige Farbe erzeugen und mit Textur multiplizieren
	mat.albedo_color = Color.from_hsv(randf(), randf_range(0.6, 1.0), randf_range(0.8, 1.0))
	# Material zuweisen
	$floor.material = mat
	
	wall_mat.uv1_triplanar = true
	wall_mat.albedo_texture = load("res://floor_texture.png")
	var gray = randf_range(0.3, 0.7)
	wall_mat.albedo_color = Color(gray, gray, gray)

func createStreet(dir: String):
	print("generating tile on the: ", dir)
	match dir:
		"center":
			createCross() # immer Cross
		"north":
			var choice = randi() % 4
			match choice:
				0:
					createCorner([180, 270][randi() % 2])
				1:
					createCross()
				2:
					createStraight(0)
				3:
					createTCross([180, 90, 270][randi() % 3])
		"east":
			var choice = randi() % 4
			match choice:
				0:
					createCorner([180, 90][randi() % 2])
				1:
					createCross()
				2:
					createStraight(90)
				3:
					createTCross([0, 180, 90][randi() % 3])
		"south":
			var choice = randi() % 4
			match choice:
				0:
					createCorner([0, 90][randi() % 2])
				1:
					createCross()
				2:
					createStraight(0)
				3:
					createTCross([90, 0, 270][randi() % 3])
		"west":
			var choice = randi() % 4
			match choice:
				0:
					createCorner([270, 0][randi() % 2])
				1:
					createCross()
				2:
					createStraight(90)
				3:
					createTCross([0, 270, 180][randi() % 3])


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name == "spieler":
		emit_signal("player_entered", self)
		
func createCross():
	print("cross generiert")
	var walls = Node3D.new()
	
	var size = Vector3(5.0, 20.0, 5.0)
	var positions = [
		Vector3(7.5, 30, 7.5),
		Vector3(7.5, 30, -7.5),
		Vector3(-7.5, 30, 7.5),
		Vector3(-7.5, 30, -7.5)
	]
	
	for pos in positions:
		var box = CSGBox3D.new()
		box.size = size
		box.position = pos
		box.use_collision = true
		box.material = wall_mat
		walls.add_child(box)
	add_child(walls)

func createCorner(rot: int):
	print("corner generiert mit ", rot, "°")
	var walls = Node3D.new()
	var sizes = [
		Vector3(15.0, 20.0, 5.0),
		Vector3(5.0, 20.0, 15.0),
		Vector3(5.0, 20.0, 5.0)
	]
	var positions = [
		Vector3(2.5, 30.0, 7.5),
		Vector3(-7.5, 30.0, -2.5),
		Vector3(7.5, 30.0, -7.5)
	]
	
	for pos in positions:
		var box = CSGBox3D.new()
		box.position = pos
		box.size = sizes[positions.find(pos)]
		box.use_collision = true
		box.material = wall_mat
		walls.add_child(box)
	walls.rotation_degrees = Vector3(0, rot, 0)
	add_child(walls)

func createStraight(rot: int):
	print("straight generiert mit ", rot, "°")
	var walls = Node3D.new()
	var size = Vector3(5.0, 20.0, 20.0)
	var positions = [
		Vector3(7.5, 30.0, 0.0),
		Vector3(-7.5, 30.0, 0.0)
	]
	for pos in positions:
		var box = CSGBox3D.new()
		box.position = pos
		box.size = size
		box.use_collision = true
		box.material = wall_mat
		walls.add_child(box)
	walls.rotation_degrees = Vector3(0, rot, 0)
	add_child(walls)

func createTCross(rot: int):
	print("T Cross generiert mit ", rot, "°")
	var walls = Node3D.new()
	var sizes = [
		Vector3(20.0, 20.0, 5.0),
		Vector3(5.0, 20.0, 5.0),
		Vector3(5.0, 20.0, 5.0)
		]
	var positions = [
		Vector3(0.0, 30.0, 7.5),
		Vector3(7.5, 30.0, -7.5),
		Vector3(-7.5, 30.0, -7.5)
	]
	for pos in positions:
		var box = CSGBox3D.new()
		box.position = pos
		box.size = sizes[positions.find(pos)]
		box.use_collision = true
		box.material = wall_mat
		walls.add_child(box)
	walls.rotation_degrees = Vector3(0, rot, 0)
	add_child(walls)
