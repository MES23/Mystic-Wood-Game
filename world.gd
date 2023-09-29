extends TileMap

@onready var minimap = $CanvasLayer/Minimap

func _ready():
	for object in get_tree().get_nodes_in_group("minimap_objects"):
		object.removed.connect(minimap._on_object_removed)


func _on_door_door():
	$Player.position = $Marker2D.position
