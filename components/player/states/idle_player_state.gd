class_name IdlePlayerState extends MovementPlayerState

func physics_update(delta) -> void:
	PLAYER.rotate_to_gravity()
	if Input.is_action_pressed("Jump"): jump()
	PLAYER.move_and_slide()
	
	if Input.is_action_just_pressed("Crouch (Hold)") or Input.is_action_just_pressed("Crouch (Toggle)"):
		transition.emit("CrouchedPlayerState")
		return
	elif !PLAYER.is_on_floor():
		if FALL_CAST.is_colliding() and !Input.is_action_pressed("Jump"):
			PLAYER.apply_floor_snap()
		else:
			transition.emit("AirPlayerState")
	if PLAYER.get_horisontal_direction():
		transition.emit("RunningPlayerState")
		return
