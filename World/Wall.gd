extends Area2D

export (Vector2) var normal_vector

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	normal_vector = Vector2(0, -1).rotated(rotation).normalized()

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
