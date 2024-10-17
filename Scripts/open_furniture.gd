extends RigidBody3D

var opening: bool = false;
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func use():
	if opening:
		animation_player.play_backwards("open")
	else:
		animation_player.play("open")
