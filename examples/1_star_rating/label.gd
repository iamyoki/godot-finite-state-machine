extends Label


func _on_finite_state_machine_transitioned(_from: State, to: State) -> void:
	var value = int(to.name)
	
	if value <= 5:
		text = 'The best!!!'
		
	if value <= 4:
		text = 'Awesome!!!'
		
	if value <= 3:
		text = 'great!'
		
	if value <= 1:
		text = 'good!'
