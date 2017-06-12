extends Node2D
var str_curBtn
var bool_btn1 = 0
var bool_btn2 = 0
var bool_btn3 = 0
var bool_btn4 = 0

func _input(event):
	# Handle the first pressed key
	print(event)
	if (event.type == InputEvent.KEY):
		get_node("Label_"+str_curBtn).set_text("KEY BOARD " +str(event.device))
		binding(0, event.device)
		set_process_input(false)
	if (event.type == InputEvent.JOYSTICK_BUTTON):
		#print(event.device)
		get_node("Label_"+str_curBtn).set_text("JOY " + str(event.device))
		binding(1, event.device)
		set_process_input(false)

func binding(kind, device):
	if(str_curBtn == "Button1"): 
		global.input_kind[0]=kind
		global.input_device[0]=device
	if(str_curBtn == "Button2"): 
		global.input_kind[1]=kind
		global.input_device[1]=device
	if(str_curBtn == "Button3"): 
		global.input_kind[2]=kind
		global.input_device[2]=device
	if(str_curBtn == "Button4"): 
		global.input_kind[3]=kind
		global.input_device[3]=device
	pass

func _ready():
	var str_ik = []#輸入型態暫存
	
	#綁定callback
	for x in range(4):
		get_node("Button"+str(x+1)).connect("pressed", self, "_on_Button"+str(x+1)+"_pressed")
	
	#填入預設值
	if(global.player.size()==0):
		for x in range(global.player_amount):
			global.player.append(0)
			global.input_device.append(0)
			global.input_kind.append(0)
	
	#預設值/已存值顯示
	for x in range(4):
		if(global.input_kind[x]): str_ik.append("JOYSTICK")
		else: str_ik.append("KEYBOARD")
	for x in range(4):
		get_node("Label_Button" + str(x+1)).set_text(str_ik[x]+str(global.input_device[x]))
#	set_fixed_process(true)	#------------------設定loop
	pass

func _fixed_process(delta):
	pass

func _on_Button1_pressed():
	bool_btn1 = !bool_btn1				#切換 玩/不玩
	global.player[0] = bool_btn1		#填入global
	get_node("Label").set_text('set P1')#提示
	str_curBtn = "Button1"				#填入暫存
	set_process_input(true)				#註冊事件
	pass # replace with function body


func _on_Button2_pressed():
	bool_btn2 = !bool_btn2
	global.player[1] = bool_btn2
	get_node("Label").set_text('set P2')
	str_curBtn = "Button2"
	set_process_input(true)
	pass # replace with function body

func _on_Button3_pressed():
	bool_btn3 = !bool_btn3
	global.player[2] = bool_btn3
	get_node("Label").set_text('set P3')
	str_curBtn = "Button3"
	set_process_input(true)
	pass # replace with function body

func _on_Button4_pressed():
	bool_btn4 = !bool_btn4
	global.player[3] = bool_btn4
	get_node("Label").set_text('set P4')
	str_curBtn = "Button4"
	set_process_input(true)
	pass # replace with function body


func _on_Send_pressed():
	get_tree().change_scene("res://scene/game.scn")
	pass # replace with function body