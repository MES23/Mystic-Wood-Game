extends Area2D

var minimap_icon = "alert"
signal removed

func _ready():
	hide()
	$CollisionShape2D.disabled = true


func _on_body_entered(body):
	body.healthelixer()
	removed.emit(self)
	queue_free()


func _on_chest_dropiteam():
	show()
	$AnimationPlayer.play("spawn")
