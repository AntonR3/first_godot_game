extends RigidBody3D
@onready var model = %AnimationLibrary_Godot_Standard

@onready var player = get_node("/root/game/spieler")

#noch minimal zu schnell
var walkspeed = 1.5

#noch etwas zu langsam wahrscheinlich
var jogspeed = 4.0

func _ready():
	freeze = true
	lock_rotation = true
	model.playIdle()
	
func _physics_process(_delta: float) -> void:
	var direction = global_position.direction_to(player.global_position)
	var distance = global_position.distance_to(player.global_position)
	if distance < 2.0:
		model.playIdle()
	elif distance >= 1.0 and distance < 7.0:
		model.playWalk()
		direction.y = 0.0
		linear_velocity = direction * walkspeed
	else:
		model.playJog()
		direction.y = 0.0
		linear_velocity = direction * jogspeed
	model.rotation.y = Vector3.FORWARD.signed_angle_to(direction, Vector3.UP) + PI
