class_name PlayerMovementState extends State

var PLAYER: Player
var PLAYER_ANIMATION_PLAYER: AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await owner.ready
	PLAYER = owner as Player
	PLAYER_ANIMATION_PLAYER = PLAYER.ANIMATION_PLAYER

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
