class_name Openable extends RigidBody3D

var opening: bool = false;
@export var animation_player: AnimationPlayer

func use():
	if opening:
		animation_player.play_backwards("open")
		opening = false
	else:
		animation_player.play("open")
		opening = true
