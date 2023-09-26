extends Label

func _ready():
	hide()

func _on_player_endgame():
	show()
