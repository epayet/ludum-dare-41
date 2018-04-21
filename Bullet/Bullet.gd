extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass
	
func set_target_position(target_position):
	$Tween.interpolate_property(self, "position", self.position, target_position, 3, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
