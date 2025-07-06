extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Update.connect("timeout", update)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	#set_health_max(SetMaxHealth)
	#set_health(SetHealth)
	pass
	

func update() -> void:
	var velocity: float = roundf($"..".velocity.length()*100)/100
	$Velocity/meter.value = velocity
	$Velocity/value.text = str(velocity)
	print(velocity)
