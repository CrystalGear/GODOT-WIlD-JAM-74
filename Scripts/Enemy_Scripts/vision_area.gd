extends Area3D
#
#signal player_entered()
#signal player_exited()
#
## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#body_entered.connect(_on_body_enter)
	#body_exited.connect(_on_body_exit)
	#
	#var parent = get_parent()
	#if parent is Enemy:
		#parent.direction_changed.connect(_on_direction_change)
#
#
#func _on_body_enter(_b : Node3D ) -> void:
	#if _b is Player:
		#player_entered.emit()
	#pass
#
#func _on_body_exit(_b : Node3D ) -> void:
	#if _b is Player:
		#player_exited.emit()
	#pass
#
#func _on_direction_change (new_direction : Vector3 ) -> void:
	#match new_direction:
		#Vector3.FORWARD:
			#rotation_degrees.y = 0
		#Vector3.BACK:
			#rotation_degrees.y = 180
		#Vector3.LEFT:
			#rotation_degrees.y = 90
		#Vector3.RIGHT:
			#rotation_degrees.y = 270
		#_:
			#rotation_degrees.y = 0
		#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
