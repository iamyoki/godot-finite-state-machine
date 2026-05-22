@tool
class_name FiniteStateMachine
extends Node

@export var initial_state: State
@onready var current_state: State = initial_state

var _states: Dictionary[String, State]

## Notify when current state transitioned (from->to)
signal transitioned(from: State, to: State)

func _get_configuration_warnings() -> PackedStringArray:
	var warnings = PackedStringArray()
	var children = get_children()
	if children.is_empty():
		warnings.append('Please add some State nodes, and extend the script to define it\'s lifecycle behavior')
	for node in children:
		if node is State:
			if node.get_script() == State:
				warnings.append('%s: Right click and select "Extend Script" to extend the state behavior' % node.name)
	return warnings

func _init() -> void:
	child_entered_tree.connect(func(node: Node):
		if node is State:
			_states[node.name] = node
			node.set('_finite_state_machine', self)
			_sync_initial_state()
	)
	child_exiting_tree.connect(func(node: Node):
		if node is State:
			_states.erase(node.name)
			_sync_initial_state()
	)

func _ready() -> void:
	#register states
	for node in get_children():
		if node is State:
			_states[node.name] = node
			node.set('_finite_state_machine', self)

	_sync_initial_state()
	
	#enter at first
	if current_state:
		current_state.enter()

func _sync_initial_state():
	var first_state: State
	if _states.values():
		first_state = _states.values()[0]
	if not initial_state and first_state:
		initial_state = first_state
	if not current_state and first_state:
		current_state = first_state
	
func transition(to: String):
	var to_state: State = _states[to]
	if to_state:
		current_state.exit()
		to_state.enter()
		transitioned.emit(current_state, to_state)
		current_state = to_state

func _process(delta: float) -> void:
	if Engine.is_editor_hint(): return
	if current_state:
		current_state.update(delta)
		
func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint(): return
	if current_state:
		current_state.physics_update(delta)
