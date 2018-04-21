extends Node2D

var SPEED = 200

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass
	
func set_target_position(target_position):
	var time_to_target = self.position.distance_to(target_position) / SPEED
	$Tween.interpolate_property(self, "position", self.position, target_position, time_to_target, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
