extends NavigationRegion3D


# Called when the node enters the scene tree for the first time.
func _ready():
    if not is_in_group("navRegion"):
        add_to_group("navRegion")
