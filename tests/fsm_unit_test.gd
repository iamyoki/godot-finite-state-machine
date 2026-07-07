@tool
extends EditorScript

var state_enter_sequence = []
var state_exit_sequence = []
var state_update_sequence = []
var state_physics_update_sequence = []

class MockState extends State:
	var host: EditorScript
	func _init(_host: EditorScript, _name: String) -> void:
		host = _host
		name = _name
		id = name
	func enter():
		host.state_enter_sequence.append(self)
	func exit():
		host.state_exit_sequence.append(self)
	func update(_delta: float):
		host.state_update_sequence.append(self)
	func physics_update(_delta: float):
		host.state_physics_update_sequence.append(self)

func _run() -> void:
	var fsm = FiniteStateMachine.new()
	fsm.is_editor = false
	assert(fsm.current_state == null)
	
	var state_p1 = MockState.new(self, 'p1')
	var state_p1_s1 = MockState.new(self, 'p1_s1')
	var state_p1_s2 = MockState.new(self, 'p1_s2')
	
	var state_p2 = MockState.new(self, 'p2')
	var state_p2_s1 = MockState.new(self, 'p2_s1')
	var state_p2_s2 = MockState.new(self, 'p2_s2')

	
	fsm.initial_state = state_p1_s1
	state_p1.add_child(state_p1_s1)
	state_p1.add_child(state_p1_s2)
	state_p2.add_child(state_p2_s1)
	state_p2.add_child(state_p2_s2)
	
	fsm.add_child(state_p1)
	fsm.add_child(state_p2)
	fsm._enter_tree()
	fsm._ready()
	
	# initial p1_s1
	assert(fsm.current_state == state_p1_s1)
	assert(state_enter_sequence == [state_p1, state_p1_s1])
	assert(state_exit_sequence == [])
	state_enter_sequence.clear()
	state_exit_sequence.clear()
	
	# p1_s1 to p1_s1, expect nothing changes
	fsm.transition('p1/p1_s1')
	assert(fsm.current_state == state_p1_s1)
	assert(state_enter_sequence == [])
	assert(state_exit_sequence == [])
	state_enter_sequence.clear()
	state_exit_sequence.clear()
	
	# p1_s1 to p1_s2
	fsm.transition('p1/p1_s2')
	assert(state_enter_sequence == [state_p1_s2])
	assert(state_exit_sequence == [state_p1_s1])
	state_enter_sequence.clear()
	state_exit_sequence.clear()
	
	# p1_s2 to p2
	fsm.transition('p2')
	assert(state_enter_sequence == [state_p2])
	assert(state_exit_sequence == [state_p1_s2, state_p1])
	state_enter_sequence.clear()
	state_exit_sequence.clear()
	
	# p2 to p2_s1
	fsm.transition('p2/p2_s1')
	assert(state_enter_sequence == [state_p2_s1])
	assert(state_exit_sequence == [])
	state_enter_sequence.clear()
	state_exit_sequence.clear()
	
	# p2_s1 update and physics update
	fsm.notification(fsm.NOTIFICATION_PROCESS)
	fsm.notification(fsm.NOTIFICATION_PHYSICS_PROCESS)
	assert(state_update_sequence == [state_p2, state_p2_s1])
	assert(state_physics_update_sequence == [state_p2, state_p2_s1])
	state_update_sequence.clear()
	state_physics_update_sequence.clear()
