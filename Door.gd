extends Node2D
signal door

func _on_neardoor_body_entered(_body):
	$AnimationPlayer.play("Open")


func _on_neardoor_body_exited(_body):
	$AnimationPlayer.play_backwards("Open")


func _on_enterdoor_body_entered(_body):
	door.emit()
