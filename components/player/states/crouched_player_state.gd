class_name CrouchedPlayerState extends MovementPlayerState

@export var CROUCHING_SPEED := 3.0
@export var SPEED := 3.0
@export var ACCELERATION := 0.5
@export var FRICTION := 0.75

@export var SHAPE_CAST: ShapeCast3D

func enter() -> void:
	PLAYER_ANIMATION_PLAYER.play("Crouch", -1.0, CROUCHING_SPEED)

func physics_update(delta: float) -> void:
	var is_jumping := Input.is_action_pressed("Jump") and !(PLAYER_ANIMATION_PLAYER.current_animation == "Crouch" and PLAYER_ANIMATION_PLAYER.is_playing())
	if PLAYER.is_on_floor():
		move(delta, SPEED, ACCELERATION, FRICTION)
		if is_jumping: jump()
		PLAYER.move_and_slide()
		PLAYER.rotate_to_gravity()
		if !PLAYER.is_on_floor():
			if FALL_CAST.is_colliding() and !is_jumping:
				PLAYER.apply_floor_snap()
	else:
		move_air(delta, SPEED)
		PLAYER.apply_gravity(delta)
		PLAYER.move_and_slide()
		PLAYER.rotate_to_gravity()
	
	if Input.is_action_just_released("Crouch (Hold)") or Input.is_action_just_pressed("Crouch (Toggle)"):
		uncrouch()
		return

func uncrouch() -> void:
	if !SHAPE_CAST.is_colliding() and !Input.is_action_pressed("Crouch (Hold)"):
		PLAYER_ANIMATION_PLAYER.play("Crouch", -1.0, -CROUCHING_SPEED * 1.5, true)
		if PLAYER_ANIMATION_PLAYER.is_playing(): 
			await PLAYER_ANIMATION_PLAYER.animation_finished
		if PLAYER.is_on_floor(): transition.emit("IdlePlayerState")
		else: transition.emit("AirPlayerState")
	else:
		await get_tree().create_timer(0.1).timeout
		uncrouch()
