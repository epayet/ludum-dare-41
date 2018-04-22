extends RigidBody2D

signal action_done

var SPEED = 800
var _direction = null
var ttl = 5

func _ready():
	var ttl = 5
	var timer = Timer.new()
	timer.connect("timeout",self,"_on_timer_timeout")
	add_child(timer) #to _process
	timer.set_wait_time(5)
	timer.start() #to start
	contacts_reported = 1

func _process(delta):
	pass
		
func _on_timer_timeout():
	emit_signal("action_done")
	queue_free()

func _integrate_forces(state):
	if state.get_contact_count():
		var body = state.get_contact_collider_object(0)
		if body.is_in_group("blocks"):
			body.hit_by_bullet(self, state.get_contact_local_normal(0))
		ttl -= 1
		if ttl == 0:
			emit_signal("action_done")
			queue_free()

