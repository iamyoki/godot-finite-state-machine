## Base class for State.
##
## Extend it with your own lifecycle funcs (enter, update, physics_update, exit).
##
## Use transition(to: String) to trigger state switches.
class_name State
extends Node

var _finite_state_machine: FiniteStateMachine

func enter():
	pass

@warning_ignore('unused_parameter')
func update(delta: float):
	pass

@warning_ignore('unused_parameter')
func physics_update(delta: float):
	pass

func exit():
	pass

func transition(to: String):
	if _finite_state_machine:
		_finite_state_machine.transition(to)
