extends StaticBody2D


func _on_neardoor_body_entered(body):
	$AnimationPlayer.play("Open")


func _on_neardoor_body_exited(body):
	$AnimationPlayer.play_backwards("Open")


func _on_enterdoor_body_entered(body):
	body.door()
