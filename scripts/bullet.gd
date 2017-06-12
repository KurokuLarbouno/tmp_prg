extends Area2D

export var sp = 60
var a 
var motion = Vector2()
var speedup = Input.is_action_pressed("speedup")
var speeddown = Input.is_action_pressed("speeddown")
var t = 0
var owner_name#-----------------------------------儲存發射者名

func _ready():
	set_fixed_process(true)
	if(owner_name == "player"):
		a= -atan2((get_global_mouse_pos().x -  get_pos().x),(get_global_mouse_pos().y -  get_pos().y))#確定發射角度
		a = a + PI/2
		print("YOY"+str(a))
	elif(owner_name == "player_null"):
		a = -atan2(Input.get_joy_axis(0, JOY_AXIS_2), Input.get_joy_axis(0,JOY_AXIS_3))
		a = a + PI/2
	t = 0
	sp = get_parent().bullet_sp#-----------------找到game.scene節點
func _fixed_process(delta):
	motion = Vector2(cos(a)*sp*delta, sin(a)*sp*delta)
	translate(motion)
	t +=1
	
	if(t>1000):
		self.free()
func _on_bullet_body_enter( body ):
	
	for i in range(body.get_groups().size()):
		if(body.get_groups()[i]=="wall"):
			t=1000#結束子彈
		if(body.get_groups()[i]=="player_group"):
			if(body.get_name() != owner_name):
				t=1000#結束子彈
				body.hurt(get_node("../floor/"+owner_name).bullet_dmg)
	pass
	
func set_owner(var owname):
	owner_name = owname
	pass
