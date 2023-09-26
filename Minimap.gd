extends MarginContainer

@export var player: Player
@export var zoom = 1.5:
	set = set_zoom

@onready var grid = $MarginContainer/Grid
@onready var player_marker = $MarginContainer/Grid/playermaker
@onready var mob_marker = $MarginContainer/Grid/modmarker
@onready var alert_marker = $MarginContainer/Grid/alertmarker

@onready var icons = {"mob": mob_marker, "alert": alert_marker}

var grid_scale
var markers = {}

func _ready():
	await get_tree().process_frame
	player_marker.position = grid.size / 2
	grid_scale = grid.size / (get_viewport_rect().size * zoom)
	
	var map_objects = get_tree().get_nodes_in_group("minimap_objects")
	for item in map_objects:
		var new_marker = icons[item.minimap_icon].duplicate()
		grid.add_child(new_marker)
		new_marker.show()
		markers[item] = new_marker


func _process(_delta):
	if !player:
		return
	
	var rot
	if player.facing.find("left") != -1:
		rot = PI/2
	elif player.facing.find("up") != -1:
		rot = 0
	else:
		rot = PI
	
	player_marker.rotation = rot
	for item in markers:
		var obj_pos = (item.position - player.position) * grid_scale + grid.size / 2
		obj_pos = obj_pos.clamp(Vector2.ZERO, grid.size)
		markers[item].position = obj_pos
		if grid.get_rect().has_point(obj_pos + grid.position):
			markers[item].scale = Vector2(1, 1)
		else:
			markers[item].scale = Vector2(0.75, 0.75)

func set_zoom(value):
	zoom = clamp(value, 0.5, 5)
	grid_scale = grid.size / (get_viewport_rect().size * zoom)

func _on_object_removed(object):
	if object in markers:
		markers[object].queue_free()
		markers.erase(object)

#func _on_gui_input(event):
#	if event is InputEventMouseButton and event.pressed:
#		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
#			zoom += 0.1
#		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
#			zoom -= 0.1
