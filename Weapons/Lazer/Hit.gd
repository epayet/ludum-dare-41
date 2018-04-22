extends Sprite

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	visible = false
	$anim.connect("animation_finished", self, "animation_finished")

func animation_finished(name):
	queue_free()

func play():
	$anim.play("hit")
	visible = true
