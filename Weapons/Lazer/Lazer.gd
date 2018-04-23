extends Node2D

signal action_done

var target
var cur_length = 0
var next_length = null
var current_hit

const SPEED = 1000

func _ready():
	$Tween.connect("tween_completed", self, "lazer_step_complete")
	$AudioStreamPlayer.play()

func _process(delta):
	$Body.region_rect = Rect2(0, 0, 8, cur_length)

func _physics_process(delta):
	if target == null:
		$RayCast.force_raycast_update()
		if $RayCast.is_colliding():
			target = $RayCast.get_collider()
			var normal = $RayCast.get_collision_normal()
			var hit_pos = $RayCast.get_collision_point()
			current_hit = preload("res://Weapons/Lazer/Hit.tscn").instance()
			current_hit.position = hit_pos
			current_hit.rotation = -normal.angle_to(Vector2(0, 1))
			
			get_parent().add_child(current_hit)
			
			next_length = hit_pos.distance_to(position)
			var duration = max(0.01, (next_length - cur_length) / SPEED)
			$Tween.interpolate_property(self, "cur_length", cur_length, next_length, duration, Tween.TRANS_LINEAR, Tween.EASE_OUT_IN)
			$Tween.start()
		else:
			emit_signal("action_done")
			queue_free()

func lazer_step_complete(object, key):
	if target != null and target.is_in_group("blocks") and not target.is_unbreakable():
		current_hit.play()
		target.queue_free()
		target = null
	elif target != null and (target.is_in_group("walls") or target.is_in_group("blocks") and target.is_unbreakable()):
		emit_signal("action_done")
		queue_free()