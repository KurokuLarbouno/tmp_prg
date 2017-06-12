extends KinematicBody2D
#-----------------------------------
#export:
#	MOTION_SPEED
#	BULLET_CHANGE_TME
#--------------------------------腳色管理
var player = 0
var input_kind = 0
var input_device = 0
var player_kind = 0
#-----------------------------------
var player_health
var HEALTH = 200
#---------------------------子彈部分
export var BULLET_QUANTITY = 10
var bulletQ		#子彈數紀錄
export var BULLET_CHANGE_TME = 1
var bulletT		#換彈時間紀錄
var prepared
var bullet_speed = 60
var bullet_dmg = 30
#----------------------------------
#---------------------------陷阱部分
var bag_trap = []
var player_sprite
var bag_trap_switch_num = 0
var putTrap_flag = false
var ui_Q_trap_switch_flag = false
var ui_E_trap_switch_flag = false
var banana_trap_effect_flag = false
var banana_time  #香蕉滑行時間
var banana_time_control = 0.5 #香蕉滑行時間控制
var banana_time_flag = false
var trap_node_register
var banana_save_motion = Vector2()#保留移動方向用
#----------------------------------
#---------------------------移動部分
export var MOTION_SPEED = 140
var t
#---------------------------動畫
var anim
var new_anim
#---------------------------血量
export var health = 200
#----------------------------------
#----------------------------------死亡及無敵及受擊
var die = false
var hurt_flag = false
var TOGGLE_TIME = 0.1#閃爍頻率
var FLASH_TIME = 3#無敵時間
var LITTLE_FLASH_TIME = 0.5#受擊無敵時間
var ALIVE_TIME = 2#重生時間
var toggleT#閃爍時間紀錄
var flashT#無敵時間紀錄
var LflashT#受擊無敵時間紀錄
var aliveT#重生時間紀錄
var visible_state = true

func _ready():
	
	reset()#-----------------------------------子彈部分
	set_fixed_process(true)	#------------------設定loop
	player_sprite = get_node("player_Sprite")#-實現陷阱改player色效果
	
func _fixed_process(delta):
#-----------------------------------------------輸入狀態
	var shooting = Input.is_action_pressed("shoot")
	var reload = Input.is_action_pressed("ui_reload_P1")
#-----------------------------------------------移動	
	var motion = Vector2()
	#----------------------------------------------------移動部分
	if (input_kind):#-----------------------joystick
		if (Input.get_joy_axis(input_device, 1)<-0.3): # up
			motion += Vector2(0, Input.get_joy_axis(input_device, 1))
		if (Input.get_joy_axis(input_device, 1)> 0.3): #down
			motion += Vector2(0, Input.get_joy_axis(input_device, 1))
		if (Input.get_joy_axis(input_device, 0)<-0.3): #left
			motion += Vector2(Input.get_joy_axis(input_device, 0), 0)
		if (Input.get_joy_axis(input_device, 0)> 0.3): #right
			motion += Vector2(Input.get_joy_axis(input_device, 0), 0)
	else:#----------------------------------keyboard
		if (Input.is_action_pressed("ui_up")):
			motion += Vector2(0, -1)
		elif (Input.is_action_pressed("ui_down")):
			motion += Vector2(0, 1)
		elif (Input.is_action_pressed("ui_left")):
			motion += Vector2(-1, 0)
		elif (Input.is_action_pressed("ui_right")):
			motion += Vector2(1, 0)
	motion = motion.normalized()*MOTION_SPEED*delta
	if(motion.x > 0): new_anim = "walk_right"
	elif(motion.x < 0): new_anim = "walk_left"
	elif(motion!=Vector2(0,0)): new_anim = "walk"
	else: new_anim = "stop"
	
	move(motion)
	
	var slide_attempts = 1
	while(is_colliding() and slide_attempts > 0):
		motion = get_collision_normal().slide(motion)
		motion = move(motion*1.5)
		slide_attempts -= 1
#-----------------------------------------------動畫
	if (new_anim != anim):
		anim = new_anim
		get_node("player_Sprite/anim").play(anim)
		
#-----------------------------------------------陷阱
	
	if motion != Vector2(0, 0) && !banana_trap_effect_flag:
		banana_save_motion = motion
	if banana_trap_effect_flag:#香蕉特效
		if !banana_time_flag:
			banana_time = 0
			banana_time_flag = !banana_time_flag
		
		if  banana_time >banana_time_control:
			banana_time_flag = !banana_time_flag
			banana_trap_effect_flag = false
		else: 
			banana_time += delta
			move(banana_save_motion*35*delta/banana_time_control)
	
	if (Input.is_action_pressed("ui_E_trap_switch")):
		if(!ui_E_trap_switch_flag):
			ui_E_trap_switch_flag = true
		
			if(bag_trap.size() != 0):
				if bag_trap_switch_num != 0:#放回背包
					trap_node_register.set_pos(get_node("../trash").get_global_pos())
					set_opacity ( 1 )
					trap_node_register.player_putdown_trap_flag = false
				bag_trap_switch_num += 1
				if(bag_trap_switch_num > bag_trap.size()):
					bag_trap_switch_num = 0

			else:#maybe not use
				bag_trap_switch_num = 0

	if (Input.is_action_pressed("ui_Q_trap_switch")):
		if(!ui_Q_trap_switch_flag):
			ui_Q_trap_switch_flag = true
			if(bag_trap.size() != 0):#放回背包
				if bag_trap_switch_num != 0:
					trap_node_register.set_pos(get_node("../trash").get_global_pos())
					set_opacity ( 1 )
					trap_node_register.player_putdown_trap_flag = false
				#get_node("../"+bag_trap[0]).set_pos(get_node("shootfrom").get_global_pos())
				#bag_trap.remove ( 0 )
				bag_trap_switch_num -= 1
				if(bag_trap_switch_num < 0):
					bag_trap_switch_num = bag_trap.size()

			else:#maybe not use
				bag_trap_switch_num = 0
	if (Input.is_action_pressed("putTrap")):#space
		
		if(!putTrap_flag):
			putTrap_flag = true
			if(bag_trap.size() != 0):
				if bag_trap_switch_num != 0:
					trap_node_register = get_node("../"+bag_trap[bag_trap_switch_num-1])
					trap_node_register.set_pos(get_node("../trash").get_global_pos())
					
					trap_node_register.player_putdown_trap_flag = false
					trap_node_register.set_pos(get_node("shootfrom").get_global_pos())
					
					trap_node_register.set_opacity ( 1 )
					bag_trap.remove ( bag_trap_switch_num-1 )
					bag_trap_switch_num = 0
	if (!Input.is_action_pressed("putTrap")):
		putTrap_flag = false
	if (!Input.is_action_pressed("ui_Q_trap_switch")):
		ui_Q_trap_switch_flag = false
	if (!Input.is_action_pressed("ui_E_trap_switch")):
		ui_E_trap_switch_flag = false
	#-----------------陷阱switch
	#bag_trap_switch_num為0時，由歸0處(按鈕觸發)來進行陷阱丟垃圾桶
	if bag_trap_switch_num != 0:

		trap_node_register = get_node("../"+bag_trap[bag_trap_switch_num-1])
		trap_node_register.player_putdown_trap_flag = true
		trap_node_register.set_pos(get_node("shootfrom").get_global_pos())
		trap_node_register.set_opacity ( 0.5 )
		
		trap_node_register.set_z(1)
	#get_node("../"+bag_trap[0]).set_pos(get_node("shootfrom").get_global_pos())
	#bag_trap.remove ( 0 )
	#-----------------陷阱switch END
#---------------------------------------------------陷阱 END
#---------------------------------------------------	
#-----------------------------------------------牆壁碰撞	
#------------------------------------------------------	
	# Make character slide nicely through the world
	var slide_attempts = 1
	while(is_colliding() and slide_attempts > 0):
		motion = get_collision_normal().slide(motion)
		motion = move(motion)
		slide_attempts -= 1
	
#--------------------------------------------------------------子彈射擊
	t = delta
	
	if(shooting and prepared and bulletQ >= 0):#---------------可發射狀態
		prepared = false
		var bullet = preload("res://scene/bullet.tscn").instance()
		bullet.set_pos(get_node("shootfrom").get_global_pos())
		bullet.set_owner(self.get_name())
		get_node("../..").add_child(bullet)
		get_node("player_Sprite/anim").play("shoot")#----------射擊動畫
	
		bulletQ -= 1#------------------------------------------彈夾存入
		pass
	if(shooting != true):#-------------------------------------放手才可再射
		if(bulletQ == 0): bulletQ = -1#------------------------進入倒數
		prepared = true#---------------------------------------回復可發射狀態
		pass
	if(reload == true):
		bulletQ = -1
		pass
	if(bulletQ == -1):#----------------------------------------裝彈倒數
		bulletT -= delta
		#print(bulletT)
		if(bulletT <= 0):reset()#------------------------------重置
		pass
		
		
		
#---------------------------------------------------------------死亡
	if(die): die(delta)
#------------------------------------------------------------------
#--------------------------------------------------------------受擊
	if(hurt_flag): hurt_flash(delta)
#------------------------------------------------------------------


#----------------------------------------------子彈初始
func reset():
	prepared = true
	bulletQ = BULLET_QUANTITY
	bulletT = BULLET_CHANGE_TME
	flashT = FLASH_TIME
	LflashT = LITTLE_FLASH_TIME
	toggleT = TOGGLE_TIME
	aliveT = ALIVE_TIME
	player_health = HEALTH
	#self.set_pos()
	
	pass

#-----------------------------------------------------
#--------------------------------------------------------------無敵
func die(delta):
	aliveT -= delta
	#-----死亡動作
	if(aliveT >= 0):
		set_hidden(true)
		pass
	elif(aliveT >= -ALIVE_TIME): 
		flashT -= delta
		if(flashT >= 0):#閃爍時間
			toggleT -= delta
			if (toggleT <= 0 ):
				set_hidden(visible_state)
				visible_state = !visible_state
				toggleT = TOGGLE_TIME
				pass
		pass
	else:
		set_hidden(false)
		visible_state = true
		die = false
		reset()
		pass
#----------------------------------------------------------------------
#--------------------------------------------------------------陷阱放置
func add_trap(trap_kind):
	bag_trap.append(trap_kind)
	pass
#---------------------------------------------------------------------
#--------------------------------------------------------------受擊
func hurt(var dmg):
	if(!hurt_flag): 
		if(!die):
			player_health = player_health-dmg
			print(player_health)
			hurt_flag = true
			pass
		if(player_health <= 0):
			player_health = 0
			die = true
	pass
func hurt_flash(delta):
	LflashT -= delta
	if(LflashT >= 0):#閃爍時間
		toggleT -= delta
		if (toggleT <= 0 ):
			set_hidden(visible_state)
			visible_state = !visible_state
			toggleT = TOGGLE_TIME
		
			
			pass
	else: 
		set_hidden(false)
		visible_state = true
		hurt_flag = false
		LflashT = LITTLE_FLASH_TIME
		#reset()
	
		pass


#---------------------------------------------------------------------
#-----死亡動作