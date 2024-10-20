class_name Repairable extends Area3D

@export_category("Assign These")
@export var collectable_part: Car_part # Set this in level to the part that is deposited
@export var tool_to_repair_with: Tool # Set this in level top the part this is used to repair it
@export_category("Do not change!")
@export var static_part: Car_part
@export var part_mesh: MeshInstance3D
@export var outline_mesh: MeshInstance3D

var placed_part: bool = false
var repaired: bool = false

func _ready() -> void:
	static_part.freeze = true
	outline_mesh.visible = true
	part_mesh.visible = false

func _on_body_entered(body: Node3D) -> void:
	if body == collectable_part:
		placed_part = true
		outline_mesh.visible = false
		part_mesh.visible = true
		collectable_part.queue_free()

func repair(tool) -> bool:
	print(tool)
	if tool:
		if tool == tool_to_repair_with and not repaired:
			repaired = true
			GameManager.repaired_part()
			print("Repaired")
			return true
	return false
