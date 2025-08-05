class_name RunningPlayerState extends State

@export var ANIMATION_PLAYER: AnimationPlayer
@export var TOP_ANIM_SPEED := 2.2

func physics_update(delta: float) -> void:
	if Global.player.velocity.length() == 0:
		transition.emit("IdlePlayerState")
	if !Global.player.is_on_floor():
		transition.emit("IdlePlayerState")
	set_animation_speed(Global.player.velocity.length(), delta)

func set_animation_speed(speed: float, delta: float):
	var alpha := remap(speed, 0.0, Global.player.SPRINT_SPEED, 0.0, 1.0)
	ANIMATION_PLAYER.speed_scale = lerpf(0.0, TOP_ANIM_SPEED, alpha)

func enter():
	ANIMATION_PLAYER.play("Running", -1, 1.0)

func exit():
	ANIMATION_PLAYER.stop()
