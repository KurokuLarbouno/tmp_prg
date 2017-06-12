extends ParallaxBackground
var string

func _ready():
	get_node("Label_Health").set_text("")
	set_fixed_process(true)
	pass
func _fixed_process(delta):
	#P1 health
	get_node("Label_Health").set_text("")
	get_node("Label_Health").set_text("P1  HP: " + str(get_node("../floor/player").player_health) + "\n")
	string = get_node("Label_Health").get_text()
	if ((get_node("../floor/player").bulletQ) == -1):
		get_node("Label_Health").set_text(string + "P1  Bullet: " + "reloading"+ "\n")
	else:
		get_node("Label_Health").set_text(string + "P1  Bullet: " + str(get_node("../floor/player").bulletQ) + "\n")
	#P2 health
	get_node("Label_Health1").set_text("")
	get_node("Label_Health1").set_text("P2  HP: " + str(get_node("../floor/player_null").player_health) + "\n")
	string = get_node("Label_Health1").get_text()
	if ((get_node("../floor/player_null").bulletQ) == -1):
		get_node("Label_Health1").set_text(string + "P2  Bullet: " + "reloading"+ "\n")
	else:
		get_node("Label_Health1").set_text(string + "P2  Bullet: " + str(get_node("../floor/player_null").bulletQ) + "\n")
	pass