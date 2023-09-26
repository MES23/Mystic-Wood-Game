extends HBoxContainer


func _on_player_updatelives(value):
	for i in get_child_count():
		get_child(i).visible = value > 0
		value -= 1
