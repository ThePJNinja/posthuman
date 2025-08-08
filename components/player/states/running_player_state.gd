class_name RunningPlayerState extends MovementPlayerState

@export var TOP_ANIM_SPEED := 2.2
@export var SPEED := 7.0
@export var ACCELERATION := 2.0
@export var FRICTION := 5.0
@export var WALK_SPEED_MULTI := 0.5

func physics_update(delta: float) -> void:
	var is_jumping := Input.is_action_pressed("Jump")
	var c_speed := SPEED if !Input.is_action_pressed("Walk") else SPEED * WALK_SPEED_MULTI
	
	move(delta, c_speed, ACCELERATION, FRICTION)
	if is_jumping: jump()
	set_animation_speed(PLAYER.velocity.length())
	PLAYER.move_and_slide()
	PLAYER.rotate_to_gravity()
	if !PLAYER.is_on_floor():
		if FALL_CAST.is_colliding() and !is_jumping:
			PLAYER.apply_floor_snap()
		else:
			transition.emit("AirPlayerState")
	
	if Input.is_action_just_pressed("Crouch (Hold)") or Input.is_action_just_pressed("Crouch (Toggle)"):
		transition.emit("CrouchedPlayerState")
	elif PLAYER.velocity.length() == 0:
		transition.emit("IdlePlayerState")

func set_animation_speed(speed: float) -> void:
	var alpha := remap(speed, 0.0, SPEED, 0.0, 1.0)
	PLAYER_ANIMATION_PLAYER.speed_scale = lerpf(0.0, TOP_ANIM_SPEED, alpha)

func enter() -> void:
	PLAYER_ANIMATION_PLAYER.play("Running", -1, 1.0)

func exit() -> void:
	PLAYER_ANIMATION_PLAYER.stop()
	PLAYER_ANIMATION_PLAYER.speed_scale = 1.0
