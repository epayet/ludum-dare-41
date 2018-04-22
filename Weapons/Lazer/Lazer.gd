extends Node2D

signal action_done

var target
var cur_length = 0
var next_length = null

const SPEED = 4000

func _ready():
	$Tween.connect("tween_completed", self, "lazer_target_reached")

func _process(delta):
	$Body.region_rect = Rect2(0, 0, 8, cur_length)

func _physics_process(delta):
	if target == null:
		$RayCast.force_raycast_update()
		if $RayCast.is_colliding():
			target = $RayCast.get_collider()
			var hit_pos = $RayCast.get_collision_point()
			next_length = hit_pos.distance_to(position)
			var duration = max(0.01, (next_length - cur_length) / SPEED)
			$Tween.interpolate_property(self, "cur_length", cur_length, next_length, duration, Tween.TRANS_LINEAR, Tween.EASE_OUT_IN)
			$Tween.start()
		else:
			emit_signal("action_done")
			queue_free()
		

func lazer_target_reached(object, key):
	if target != null and target.is_in_group("blocks"):
		target.queue_free()
		target = null
	elif target != null and target.is_in_group("walls"):
		emit_signal("action_done")
		queue_free()