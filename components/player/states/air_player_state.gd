class_name AirPlayerState extends MovementPlayerState

@export var SPEED := 7.0

func physics_update(delta: float) -> void:
	PLAYER.rotate_to_gravity()
	move_air(delta, SPEED)
	PLAYER.apply_gravity(delta)
	PLAYER.move_and_slide()
	
	if Input.is_action_just_pressed("Crouch (Hold)") or Input.is_action_just_pressed("Crouch (Toggle)"):
		transition.emit("CrouchedPlayerState")
		return
	if PLAYER.is_on_floor():
		transition.emit("RunningPlayerState")
		return
