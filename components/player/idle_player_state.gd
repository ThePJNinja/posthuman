extends State



func physics_update(delta):
	if Global.player.velocity.length() > 0.0:
		transition.emit("RunningPlayerState")
