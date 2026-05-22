## Base class for State.
##
## Extend it with your own lifecycle funcs (enter, update, physics_update, exit).
##
## Use transition(to: String) to trigger state switches.
class_name State
extends Node

## Notify when this state switched (->to)
signal transitioned(to: String)

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
	transitioned.emit(to)
