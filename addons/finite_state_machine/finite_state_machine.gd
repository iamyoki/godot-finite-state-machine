@tool
class_name FiniteStateMachine
extends Node

@export var initial_state: State
@onready var current_state: State = initial_state

var _states: Dictionary[String, State]

## Notify when current state switched (from->to)
signal transitioned(from: State, to: State)

func _ready() -> void:
	child_entered_tree.connect(_sync_states_from_tree)
	child_exiting_tree.connect(_sync_states_from_tree)
	_sync_states_from_tree()
	if current_state:
		current_state.enter()
	
func _sync_states_from_tree():
	_states = {}
	for child in get_children():
		if child is State:
			_states[child.name] = child
			child.transitioned.connect(_on_state_transitioned)
			
func _on_state_transitioned(to: String):
	var to_state: State = _states[to]
	
	if to_state:
		current_state.exit()
		to_state.enter()
		transitioned.emit(current_state, to_state)
		current_state = to_state

func _process(delta: float) -> void:
	if current_state:
		current_state.update(delta)
		
func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)
