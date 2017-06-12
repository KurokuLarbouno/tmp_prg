extends Sprite

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	var shooting = Input.is_action_pressed("shoot")
	pass
#hitted condition
func hit(obj):
	pass
