extends CharacterBody2D

var speed = 40
enum states {IDLE, CHASE, ATTACK, HURT, DEAD}
var state = states.IDLE
var player
var health = 3
var minimap_icon = "mob"
@onready var startpos = global_position
var alive = true
signal removed


func _physics_process(_delta):
	choose_action()
	move_and_slide()


func choose_action():
	match state:
		states.DEAD:
			$AnimationPlayer.play("death")
			set_physics_process(false)
			$CollisionShape2D.disabled = true
			alive = false
			removed.emit(self)
		states.IDLE:
			$AnimationPlayer.play("idle")
			velocity= Vector2.ZERO
		states.CHASE:
			$AnimationPlayer.play("run")
			velocity = position.direction_to(player.position) * speed
			if velocity.x != 0:
				transform.x.x = sign(velocity.x)
		states.ATTACK:
			velocity = Vector2.ZERO
			$AnimationPlayer.play("attack")
			transform.x.x = sign(position.direction_to(player.position).x)


func _on_detect_body_entered(body):
	player = body
	state = states.CHASE

func _on_detect_body_exited(_body):
	player = null
	state = states.IDLE


func _on_attack_body_entered(_body):
	state = states.ATTACK

func _on_attack_body_exited(_body):
	if state != states.IDLE:
		state = states.CHASE

func hurt(amount, dir):
	health -= amount
	var prev_state = state
	state = states.HURT
	velocity = dir * 100
	await get_tree().create_timer(0.2).timeout
	state = prev_state
	if health <= 0:
		state = states.DEAD


func _on_hurtbox_area_entered(area):
	area.get_parent().hurt(1, position.direction_to(area.get_parent().position))


func _on_player_die():
	if alive:
		state = states.IDLE
		player = null
		position = startpos
		await get_tree().create_timer(1).timeout
