extends Camera2D
var player_pos
var camera_pos
var player 
# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	player = get_node("../../player")
	# Called every time the node is added to the scene.
	# Initialization here
	set_fixed_process(true)
	pass
func _fixed_process(delta):
	
	player_pos=player.get_global_pos()
	var player2_pos=get_node("../../player_null/").get_global_pos()
	var p = player_pos + player2_pos
	var p2 = ((player_pos.x - player2_pos.x)*(player_pos.x - player2_pos.x) + (player2_pos.y - player_pos.y)*(player2_pos.y - player_pos.y))
	p2 = sqrt(p2)*0.0018
	if(p2 < 0.20):
		p2 = 0.2
	p /= 2
	p.y += 15
	if(p != self.get_global_pos()):
		#print(player_pos)
		self.set_global_pos( Vector2(p))
	var zoom = Vector2(p2, p2)
	set_zoom(zoom)
	#print(zoom)
	pass