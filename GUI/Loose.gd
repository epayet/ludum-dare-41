extends Panel

var scale = 0

func _ready():
	get_tree().paused = true
	$Tween.interpolate_property(self, "scale", 0, 1, 1, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$Tween.start()
	
	$CenterContainer/VBoxContainer/HBox/TryAgain.connect("pressed", self, "try_again")
	$CenterContainer/VBoxContainer/HBox/MainMenu.connect("pressed", self, "main_menu")
	$DieSound.play()

func _process(delta):
	rect_scale = Vector2(scale, scale)
	var pos = (1 - scale) * 640 / 2
	rect_position = Vector2(pos, pos)

func try_again():
	get_tree().paused = false
	get_tree().change_scene("res://Game.tscn")

func main_menu():
	get_tree().paused = false
	get_tree().change_scene("res://Menu/Menu.tscn")