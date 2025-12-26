extends Node3D

	
func playIdle():
	$AnimationPlayer.play("Idle")

func playWalk():
	$AnimationPlayer.play("Walk")
	
func playJog():
	$AnimationPlayer.play("Jog_Fwd")
