class_name CrouchedPlayerState extends MovementPlayerState

@export var CROUCHING_SPEED := 3.0
@export var SPEED := 3.0
@export var ACCELERATION := 0.5
@export var FRICTION := 0.75

@export var SHAPE_CAST: ShapeCast3D

func enter() -> void:
	PLAYER_ANIMATION_PLAYER.play("Crouch", -1.0, CROUCHING_SPEED)

func physics_update(delta: float) -> void:
	PLAYER.rotate_to_gravity()
	if PLAYER.is_on_floor():
		move(delta, SPEED, ACCELERATION, FRICTION)
		if Input.is_action_pressed("Jump") and !(PLAYER_ANIMATION_PLAYER.current_animation == "Crouch" and PLAYER_ANIMATION_PLAYER.is_playing()): jump()
	elif FALL_CAST.is_colliding() and !Input.is_action_pressed("Jump"):
		PLAYER.apply_floor_snap()
		move(delta, SPEED, ACCELERATION, FRICTION)
		if Input.is_action_pressed("Jump") and !(PLAYER_ANIMATION_PLAYER.current_animation == "Crouch" and PLAYER_ANIMATION_PLAYER.is_playing()): jump()
	else:
		move_air(delta, SPEED)
		PLAYER.apply_gravity(delta)
	PLAYER.move_and_slide()
	
	if Input.is_action_just_released("Crouch (Hold)") or Input.is_action_just_pressed("Crouch (Toggle)"):
		uncrouch()

func uncrouch() -> void:
	if !SHAPE_CAST.is_colliding() and !Input.is_action_pressed("Crouch (Hold)"):
		PLAYER_ANIMATION_PLAYER.play("Crouch", -1.0, -CROUCHING_SPEED * 1.5, true)
		if PLAYER_ANIMATION_PLAYER.is_playing(): 
			await PLAYER_ANIMATION_PLAYER.animation_finished
		transition.emit("RunningPlayerState")
	else:
		await get_tree().create_timer(0.1).timeout
		uncrouch()
