extends StaticBody2D

var minimap_icon = "alert"

signal dropiteam
signal removed

func _on_area_2d_area_entered(_area):
	$AnimationPlayer.play("open")
	await $AnimationPlayer.animation_finished
	dropiteam.emit()
	removed.emit(self)
	queue_free()
