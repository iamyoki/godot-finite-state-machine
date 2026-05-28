extends Tree

@onready var label: Label = $"../Label"
@onready var fsm: FiniteStateMachine = $"../FiniteStateMachine"

func _ready() -> void:
	var root = create_item()
	
	var ground = root.create_child()
	ground.set_text(0, 'Ground')
	var ground_idle = ground.create_child()
	ground_idle.set_text(0, 'Idle')
	var ground_run = ground.create_child()
	ground_run.set_text(0, 'Running')
	
	var air = root.create_child()
	air.set_text(0, 'Air')
	var air_idle = air.create_child()
	air_idle.set_text(0, 'Idle')
	var air_flying = air.create_child()
	air_flying.set_text(0, 'Flying')
	
	label.text = 'Current state: ' + fsm.initial_state.id
	
	fsm.transitioned.connect(func(from, to):
		label.text = 'Current state: ' + fsm.current_state.id
	)
	
func _on_item_selected() -> void:
	var item: TreeItem = get_selected()
	var id = item.get_parent().get_text(0).path_join(item.get_text(0))
	fsm.transition(id)
