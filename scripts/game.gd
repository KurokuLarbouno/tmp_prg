extends Node2D


#-------------------------------trap
var generate_points_num = []#生成點編號
#----------------------------------
#-------------------------------bullet
var bullet_sp = 60#彈速
var bullet_ht = 50#傷害值
#----------------------------------
var is_clicked = false

func _ready():
	#取得玩家位置並給予輸入值
	var player = get_node("./floor/player")
	player.input_kind = global.input_kind[0]
	player.input_device = global.input_device[0]
	set_fixed_process(true)
	pass
func _fixed_process(delta):
	
	if(Input.is_action_pressed("speedup")):bullet_sp = 200
	if(Input.is_action_pressed("speeddown")):bullet_sp = 30
	var sprite = get_tree().get_nodes_in_group("sprite")
	for i in range(sprite.size()):
		var pos = sprite[i].get_global_pos()
		sprite[i].set_z(pos.y)
	pass