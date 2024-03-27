extends Label

var time = 0
var timer_on = false

func _process(delta):
	if(timer_on):
		time += delta
		
	var secs = fmod(time, 60)
	var mins = fmod(time, 60*60) / 60
	
	var time_passed = "%02d : %02d" % [mins,secs]
	text = time_passed# + " : " + var2str(time)

func _on_btn_start_pressed():
	timer_on = true


func _on_btn_faster_pressed():
	pass # Replace with function body.


func _on_btn_stop_pressed():
	timer_on = false
