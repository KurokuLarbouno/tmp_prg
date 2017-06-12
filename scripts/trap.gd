extends Area2D

var t#timer
var body_save # save enter body data
var body_save_array = []# 為了範圍大量body存入
var owner#放置者
var trap_switch = false#get or put
var trap_start = false#讓陷阱放置完，等到放置者離開才會炸
var trap_restart = false#陷阱重啟
var player_putdown_trap_flag = false#使用者是否放置陷阱還是再切換中flag 切換中true
var remove_index = []#for remove generate_points_num
var self_generate_points_num #此陷阱生成點編號
var count = 0 #count the exit times
var random_num #隨機變數
var red_time#變紅時間
var slow_time#變慢時間
var animation_time = 0#動畫時間
var scary_box_animation_time = 10#動畫時間
var random_num_flag = false#隨機變數flag
var range_trap_flag = false#範圍陷阱flag

var image = load("res://image/banana.png")#香蕉(trap1)圖

func _ready():
	if self.get_name() == "trap1":
		self.get_child(0).set_texture(image)
	if self.get_name() == "trap2":#加料汽水	
		self.get_node("Sprite/animsoda").play("Animsoda3")
	
	set_fixed_process(true)
	slow_time = 100000000
	t = 100000000
	red_time = 100000000
	connect("body_enter", self, "_on_trap_area_body_enter")#start signal
	connect("body_exit", self, "_on_trap_body_exit")#start signal
	pass
func _fixed_process(delta):

	t +=delta
	red_time +=1
	slow_time += delta
	animation_time+=delta
	scary_box_animation_time+=delta
#-----------------------------------------------動畫
	if self.get_name() == "trap2" && animation_time>1:#加料汽水	
		animation_time -= 1
		self.get_node("Sprite/animsoda").play("Animsoda3")
	
		
#-----------------------------------------------動畫 END
#-----------------------------------------陷阱效果reset
	if self.get_name() == "trap3":#驚嚇箱
			if scary_box_animation_time <10:
				if scary_box_animation_time >1:
					scary_box_animation_time = 10
					self.get_node("CollisionShape2D").set_scale(Vector2(1.0, 1.0))
					self.set_pos(get_node("../trash").get_global_pos())
					t=0
					red_time = 0
					count = 0
					range_trap_flag = false;
					
	if(red_time <= 20):
	#trap effect reset
		if self.get_name() != "trap2" && self.get_name() != "trap3":
			body_save.player_sprite.set_modulate(Color(255/(12.75*red_time),1.0,1.0))#trap effect
		elif self.get_name() == "trap3":
			for bs in body_save_array:
				bs.player_sprite.set_modulate(Color(255/(12.75*red_time),1.0,1.0))#trap effect
			#body_save_array
		else:
			body_save.player_sprite.set_modulate(Color(1.0,1.0,255/(12.75*red_time)))#trap effect
	elif body_save_array.size() != 0 :
		body_save_array = []
	if slow_time >= 3 and slow_time < 4:#變慢復原
		body_save.MOTION_SPEED = 140
	#trap effect reset END
#-----------------------------------------陷阱效果reset END
	if(t >= 5 && t<6):#陷阱重新生成
		
		
		#randi()%6+1   <---4是生成點的編號(數量)
		while(1):#禁止重複
			random_num = str( randi()%6+1 )
			#generate_points_num.append(  )
			random_num_flag = false
			
			for index in range(get_parent().get_parent().generate_points_num.size()):
				
				if int(get_parent().get_parent().generate_points_num[index]) == int(random_num) : 
					random_num_flag = true				
			if ! random_num_flag : break
		get_parent().get_parent().generate_points_num.append( random_num )

		
		self.set_gravity( int(random_num) )
		self.set_pos(get_node("../generate_points"+random_num).get_global_pos())
		t = 100000000
		red_time = 100000000
		slow_time = 100000000
		count = 0
		trap_switch = false
		trap_start = false
		trap_restart = true

func _on_trap_area_body_enter( body ):
	#print(self.get_name())
	if !player_putdown_trap_flag:
		for i in range(body.get_groups().size()):
				if(body.get_groups()[i]=="wall"):#crash wall
					t
				if(body.get_groups()[i]=="player_group"):#crash player
					#if(body.get_name() == "player"):
					if(!trap_switch):# get trap
						self.set_pos(get_node("../trash").get_global_pos())
						trap_switch = !trap_switch
						owner = body
						
						self_generate_points_num = self.get_gravity()
						for index in range(get_parent().get_parent().generate_points_num.size()):
							if int(get_parent().get_parent().generate_points_num[index]) == int(self_generate_points_num) : 
								remove_index.append(index)
								
						for index in range(remove_index.size()):
							get_parent().get_parent().generate_points_num.remove ( remove_index[0] )
							remove_index.remove(0)
						#從生成點編號陣列中去除 END
						body.add_trap(self.get_name())#把陷阱加入陷阱欄
					else:
						if trap_start || range_trap_flag:
							body_save = body
							trap_switch = !trap_switch
							trap_start = false
#-----------------------------------------trap effect 陷阱效果發生區
#-------------------------------陷阱驚跳箱效果
							
							if self.get_name() == "trap3":
								range_trap_flag = true;
								trap_switch = !trap_switch
								body_save_array.append( body ) 
								self.get_node("CollisionShape2D").set_scale(Vector2(10.0, 10.0))
								body.player_sprite.set_modulate(Color(255.0,1.0,1.0))
								self.get_node("Sprite/bun").play("bun")
								body.player_health-=15
								red_time = 0
								if(body.player_health <= 0):
									body.player_health = 0
									body.die = true	
								scary_box_animation_time = 0
#-------------------------------陷阱驚跳箱效果END			
#-------------------------------陷阱加料汽水
							
							if self.get_name() == "trap2":
								body.player_sprite.set_modulate(Color(1.0,1.0,255.0))
								body.player_health+=5
#-------------------------------陷阱加料汽水END						
							if self.get_name() == "trap":
								body.player_sprite.set_modulate(Color(255.0,1.0,1.0))
								slow_time = 0
								body.MOTION_SPEED = 70
#-------------------------------陷阱的扣血(嘔吐物？)								
								body.player_health-=5
								
								if(body.player_health <= 0):
									body.player_health = 0
									body.die = true	
#-------------------------------陷阱的扣血(嘔吐物？) END
							if self.get_name() == "trap1":
								body.player_sprite.set_modulate(Color(255.0,1.0,1.0))
								body.banana_trap_effect_flag = true
#-----------------------------------------trap effect 陷阱效果發生區END
#-------------------------------陷阱的回收區
							if self.get_name() != "trap3":
								self.set_pos(get_node("../trash").get_global_pos())
								t=0
								red_time = 0
								count = 0
#-------------------------------陷阱的回收區 END
	pass # replace with function body


func _on_trap_body_exit( body ):
	if !player_putdown_trap_flag:
#----------------------------------------此段控制是否是否玩家一觸即發trap
		trap_start = true#
		#if body == owner && count:
		#	trap_start = true
#----------------------------------------
		if !trap_restart:
		
			count += 1
		trap_restart = false
	pass #replace with function body
