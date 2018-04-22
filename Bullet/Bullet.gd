extends Node2D

signal action_done
signal hit_block(block)

var SPEED = 800
var _direction = null
var ttl = 5

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	var ttl = 5
	# Called every time the node is added to the scene.
	# Initialization here
	var timer = Timer.new()
	timer.connect("timeout",self,"_on_timer_timeout") 
	#timeout is what says in docs, in signals
	#self is who respond to the callback
	#_on_timer_timeout is the callback, can have any name
	add_child(timer) #to _process
	timer.set_wait_time(5)
	timer.start() #to start
	
func set_target_position(target_position):
	_direction = (target_position - position).normalized()
	var time_to_target = self.position.distance_to(target_position) / SPEED
	$Tween.interpolate_property(self, "position", self.position, target_position, time_to_target, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()

func _process(delta):
	pass
		
func _on_timer_timeout():
	emit_signal("action_done")
	queue_free()

func _on_Area2D_area_entered(area):
	if area.is_in_group('walls'):
		var normal = area.get("normal_vector")
		var reflect = _direction.reflect(normal)
		var destination = (reflect * 1000) * -1  # because reasons
		set_target_position(destination)
		ttl -= 1
		if ttl == 0:
			emit_signal("action_done")
			queue_free()
	else:
		# Bloc hit
		emit_signal("action_done")
		emit_signal("hit_block", area)
		queue_free()
