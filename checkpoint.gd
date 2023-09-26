extends StaticBody2D

var minimap_icon = "alert"
signal removed

func _on_area_2d_body_entered(body):
	body.setspawn()
	removed.emit(self)
