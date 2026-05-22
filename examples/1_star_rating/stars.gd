extends HBoxContainer

@onready var stars: HBoxContainer = $"."
@onready var label: Label = $"../Label"
@onready var fsm: FiniteStateMachine = $"../FiniteStateMachine"

func _ready() -> void:
	for star: TextureRect in stars.get_children():
		star.mouse_entered.connect(func():
			fsm.current_state.transition(star.name)
		)


@warning_ignore('unused_parameter')
func _on_finite_state_machine_transitioned(from: State, to: State) -> void:
	pass # Replace with function body.
