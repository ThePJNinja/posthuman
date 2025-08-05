class_name StateMachine extends Node

@export var CURRENT_STATE: State
var states: Dictionary[StringName, State] = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children():
		if child is State:
			states[child.name] = child
			child.transition.connect(on_child_transition)
		else:
			push_warning(name + " contains incompatible child node \"" + child.name + "\"")
	await owner.ready
	CURRENT_STATE.enter()

func _process(delta: float) -> void:
	CURRENT_STATE.update(delta)

func _physics_process(delta: float) -> void:
	CURRENT_STATE.physics_update(delta)

func on_child_transition(new_state_name: StringName) -> void:
	var new_state := states.get(new_state_name) as State
	if new_state != null:
		if new_state != CURRENT_STATE:
			CURRENT_STATE.exit()
			new_state.enter()
			CURRENT_STATE = new_state
		print(CURRENT_STATE)
	else:
		push_warning("State \"" + new_state_name + "\" does not exist for " + name) 
