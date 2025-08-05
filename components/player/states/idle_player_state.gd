class_name IdlePlayerState extends State

func physics_update(_delta) -> void:
	if Global.player.velocity.length() > 0.0 and Global.player.is_on_floor():
		transition.emit("RunningPlayerState")
