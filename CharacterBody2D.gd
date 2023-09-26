extends CharacterBody2D
class_name Player

var run_speed = 60
var health = 5
var lives = 3
var mxlives = 5
enum states {idle, run, attack, dead, hurt}
var state = states.run
var facing = "down"
@onready var spawnpoint = global_position
var attacking = false
signal updatelives
signal endgame

func _physics_process(_delta):
	choose_action()
	move_and_slide()

func choose_action():
	match state:
		states.dead:
			velocity = Vector2.ZERO
			$AnimationPlayer.play("death")
			await get_tree().create_timer(0.3).timeout
			die(lives)
			updatelives.emit(lives)
		states.idle:
			$AnimationPlayer.play("idle" + facing)
			checkinput()
		states.run:
			if facing.find("left") != -1:
				transform.x.x = sign(velocity.x)
			$AnimationPlayer.play("run" + facing)
			checkinput()
		states.attack:
			attacking = true
			velocity = Vector2.ZERO
			$AnimationPlayer.play("attack" + facing)
			await get_tree().create_timer(.4).timeout
			attacking = false

func checkinput():
	var input = Input.get_vector("left","right","up","down")
	velocity = input * run_speed
	
	if velocity != Vector2.ZERO:
		if velocity.x != 0:
			facing = "left"
		elif velocity.y > 0:
			facing = "down"
		else:
			facing = "up"
		state = states.run
	else:
		state = states.idle

func _input(event):
	if event.is_action_pressed("attack"):
		if attacking:
			return
		attack()

func attack():
	state = states.attack
	await get_tree().create_timer(0.4).timeout
	checkinput()


func _on_hurtbox_area_entered(area):
	area.get_parent().hurt(1, position.direction_to(area.get_parent().position))

func hurt(amount, dir):
	health -= amount
	state = states.hurt
	velocity = dir * 75
	await get_tree().create_timer(0.1).timeout
	if health <= 0:
		lives -= 1
		state = states.dead
		return
	
	checkinput()


func setspawn():
	spawnpoint = global_position

func die(l):
	if l == 0:
		endgame.emit()
		hide()
		return
	get_tree().call_group("enemies", "_on_player_die")
	state = states.idle
	global_position = spawnpoint
	health = 5

func healthelixer():
	lives = min(mxlives, lives + 1)
	health = 5
	updatelives.emit(lives)


func door():
	global_position = Vector2(4,-17)
