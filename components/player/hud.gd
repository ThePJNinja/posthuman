extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%Update.connect("timeout", timed_update)

func set_cross(texture: Texture) -> void:
	%Crosshair.texture = texture

func timed_update() -> void:
	var velocity: float = roundf($"..".velocity.length()*100)/100
	%Velocity/meter.value = velocity
	%Velocity/value.text = str(velocity)
	#print(velocity)

func set_health(value: float, max_value: float) -> void:
	%HealthBar/HealthLeft.max_value = max_value
	%HealthBar/HealthRight.max_value = max_value 
	%HealthBar/HealthLeft.set_value(value)
	%HealthBar/HealthRight.set_value(value)
	%HealthBar/HealthLabel.text = str(value) + "/" + str(max_value)
