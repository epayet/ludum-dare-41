extends Node2D

func init(to_display):
	$ScoreValueUpdate.text = "+" + str(to_display)

func _ready():
	$PlusOneAnimation.connect("animation_finished", self, "on_done")
	$PlusOneAnimation.play("score")

func on_done(anim):
	queue_free()