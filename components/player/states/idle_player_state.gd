class_name IdlePlayerState extends MovementPlayerState

func physics_update(_delta) -> void:
	var is_jumping := Input.is_action_pressed("Jump")
	if is_jumping: jump()
	PLAYER.move_and_slide()
	PLAYER.rotate_to_gravity()
	if !PLAYER.is_on_floor():
		if FALL_CAST.is_colliding() and !is_jumping:
			PLAYER.apply_floor_snap()
		else:
			transition.emit("AirPlayerState")
			return
	
	if Input.is_action_just_pressed("Crouch (Hold)") or Input.is_action_just_pressed("Crouch (Toggle)"):
		transition.emit("CrouchedPlayerState")
		return
	if PLAYER.get_horisontal_direction() or PLAYER.velocity != Vector3.ZERO:
		transition.emit("RunningPlayerState")
		return
