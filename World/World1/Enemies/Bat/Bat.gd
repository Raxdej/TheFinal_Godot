extends KinematicBody2D

const MAX_SPEED : float = 100.0
var knockback = Vector2.ZERO

var motion := Vector2()

onready var stats = $Stats

func _ready():
	$Fly.scale.x = 1
	motion.x = MAX_SPEED


func _next_to_right_wall() -> bool:
	return $RightRay.is_colliding()
	
func _next_to_left_wall() -> bool:
	return $LeftRay.is_colliding()

func _flip():
	if _next_to_right_wall() or _next_to_left_wall():
		motion.x *= -1
		$"Fly".scale.x *= -1

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, 200 * delta)
	knockback = move_and_slide(knockback)

func _on_Hurtbox_area_entered(area):
	stats.health -= 1
	knockback = Vector2.UP * 250 + Vector2.RIGHT * 150


func _on_Stats_no_health():
	$"Fly".play("Rip")


func _on_Fly_animation_finished():
	if ($"Fly".animation == "Rip"):
		queue_free()

func _process(delta):
	_flip()
	motion = move_and_slide(motion)
