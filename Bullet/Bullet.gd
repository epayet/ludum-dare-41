extends Node2D

var SPEED = 800

var _direction = null

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass
	
func set_target_position(target_position):
	_direction = (target_position - self.position).normalized()
	var time_to_target = self.position.distance_to(target_position) / SPEED
	$Tween.interpolate_property(self, "position", self.position, target_position, time_to_target, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_Area2D_area_entered(area):
	if area.is_in_group('walls'):
		var normal = area.get_node("CollisionShape2D").get("normal_vector")
		var reflect = _direction.reflect(normal)
		var destination = (reflect * 1000)
		print(destination, 'desctioansotisa')
		self.set_target_position(destination)
