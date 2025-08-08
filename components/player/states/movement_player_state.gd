class_name MovementPlayerState extends State

var PLAYER: Player
var PLAYER_ANIMATION_PLAYER: AnimationPlayer
@onready var FALL_CAST: ShapeCast3D = %FallCast

@export var JUMP_VELOCITY := 4.5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await owner.ready
	PLAYER = owner as Player
	PLAYER_ANIMATION_PLAYER = PLAYER.ANIMATION_PLAYER

func move(delta: float, speed: float, acceleration: float, friction: float) -> void:
	var direction := PLAYER.get_horisontal_direction()
	var local_velocity := PLAYER.velocity
	if direction:
		var velaccel := local_velocity.lerp(direction * speed, acceleration * delta)
		var velfric := local_velocity.lerp(direction * speed, friction * delta)
		if velfric.length() < local_velocity.length():
			local_velocity = velfric
		elif velaccel.length() < speed:
			local_velocity = velaccel
	else:
		local_velocity = local_velocity.move_toward(Vector3.ZERO, friction * delta)
	PLAYER.velocity = local_velocity

func move_air(delta: float, speed: float) -> void:
	var direction := PLAYER.get_horisontal_direction()
	var local_velocity := PLAYER.velocity
	var add_speed := speed - local_velocity.dot(direction)
	if add_speed > 0:
		var accel_speed = local_velocity.length() * delta
		if (accel_speed > add_speed):
			accel_speed = add_speed
		local_velocity += accel_speed * direction
	PLAYER.velocity = local_velocity

func jump() -> void:
	PLAYER.velocity += PLAYER.up_direction * JUMP_VELOCITY
