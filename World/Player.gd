extends KinematicBody2D

const speed = 200

var direction = 0 
var isAttaking = false #Wait until attack animation end

func _process(delta):
	var velocity = Vector2.ZERO
	#Direction (0 = Down) ( 1 = up) (2 = left) (3 = right) 
	

#Keyboard Input
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
		direction = 2
		DisabledAttack()
		isAttaking = false
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
		direction = 1
		DisabledAttack()
		isAttaking = false
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
		direction = 3
		DisabledAttack()
		isAttaking = false
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
		direction = 0
		DisabledAttack()
		isAttaking = false
	if Input.is_action_pressed("ui_accept") && (velocity == Vector2(0, 0)):
		attack_animation(direction)
		
	
	
	move_and_slide(velocity.normalized()*speed)
	player_animation(velocity)
	

#Animation Movement!!
func player_animation(velocity):
	if velocity.y > 0:
		$"AnimatedSprite".play("MoveDown")
	elif velocity.y < 0:
		$"AnimatedSprite".play("MoveUp")
	elif velocity.x != 0:
		$"AnimatedSprite".play("MoveSide")
		$"AnimatedSprite".flip_h = velocity.x > 0
	elif isAttaking == false:
		$"AnimatedSprite".stop()
		$"AnimatedSprite".frame = 0

#Make the attack animation depending on where it points
func attack_animation(direction):
	isAttaking = false
	match direction:
		0:
			$"AnimatedSprite".play("AttackDown")
			isAttaking = true
			$Hitbox/AttackDown.disabled = false
		1:
			$"AnimatedSprite".play("AttackUp")
			$Hitbox/AttackUp.disabled = false
			isAttaking = true
		2:
			$"AnimatedSprite".play("AttackSide")
			$Hitbox/AttackLeft.disabled = false
			isAttaking = true
		3: 
			$"AnimatedSprite".play("AttackSide")
			$"AnimatedSprite".flip_h
			$Hitbox/AttackRight.disabled = false
			isAttaking = true
	

func _on_AnimatedSprite_animation_finished():
	if ($"AnimatedSprite".animation == "AttackDown") or ($"AnimatedSprite".animation == "AttackUp") or ($"AnimatedSprite".animation == "AttackSide"):
		DisabledAttack()
		isAttaking = false

func DisabledAttack():
	$Hitbox/AttackDown.disabled = true
	$Hitbox/AttackLeft.disabled = true
	$Hitbox/AttackRight.disabled = true
	$Hitbox/AttackUp.disabled = true
