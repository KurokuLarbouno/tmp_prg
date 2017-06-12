extends Node2D
var player_pos
var camera_pos
var player 
# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	player = get_node("../player/shootfrom")
	# Called every time the node is added to the scene.
	# Initialization here
	set_fixed_process(true)
	pass
func _fixed_process(delta):
	
	player_pos=player.get_global_pos()
	var player2_pos=get_node("../player_null/shootfrom").get_global_pos()
	var p = player_pos + player2_pos
	p.x /= 2
	p.y /= 2
	if(p != self.get_global_pos()):
		#print(player_pos)
		self.set_global_pos( Vector2(p.x, p.y))
	pass