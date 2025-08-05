class_name RunningPlayerState extends MovementPlayerState

@export var TOP_ANIM_SPEED := 2.2
@export var SPEED := 7.0
@export var ACCELERATION := 2.0
@export var FRICTION := 3.0

func physics_update(delta: float) -> void:
	PLAYER.rotate_to_gravity()
	move(delta, SPEED, ACCELERATION, FRICTION)
	set_animation_speed(PLAYER.velocity.length(), delta)
	if Input.is_action_pressed("Jump"): jump()
	PLAYER.move_and_slide()
	
	if Input.is_action_just_pressed("Crouch (Hold)") or Input.is_action_just_pressed("Crouch (Toggle)"):
		transition.emit("CrouchedPlayerState")
	elif PLAYER.velocity.length() == 0:
		transition.emit("IdlePlayerState")
	elif !PLAYER.is_on_floor():
		if FALL_CAST.is_colliding() and !Input.is_action_pressed("Jump"):
			PLAYER.apply_floor_snap()
		else:
			transition.emit("AirPlayerState")

func set_animation_speed(speed: float, delta: float) -> void:
	var alpha := remap(speed, 0.0, SPEED, 0.0, 1.0)
	PLAYER_ANIMATION_PLAYER.speed_scale = lerpf(0.0, TOP_ANIM_SPEED, alpha)

func enter() -> void:
	PLAYER_ANIMATION_PLAYER.play("Running", -1, 1.0)

func exit() -> void:
	PLAYER_ANIMATION_PLAYER.stop()
	PLAYER_ANIMATION_PLAYER.speed_scale = 1.0
