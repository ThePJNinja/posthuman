extends CanvasLayer

@onready var health_bar_left := %HealthBar/HealthLeft as ProgressBar
@onready var health_bar_right := %HealthBar/HealthRight as ProgressBar
@onready var HealthLabel := %HealthBar/HealthLabel as Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%Update.connect("timeout", timed_update)

func timed_update() -> void:
	var velocity: float = roundf($"..".velocity.length()*100)/100
	%Velocity/meter.value = velocity
	%Velocity/value.text = str(velocity)
	#print(velocity)

func set_health(value: float) -> void:
	health_bar_left.value = value
	health_bar_right.value = value
	update_health_label()

func set_health_max(value: float) -> void:
	health_bar_left.max_value = value
	health_bar_right.max_value = value
	update_health_label()

func update_health_label() -> void:
	HealthLabel.text = str(health_bar_left.value) + "/" + str(health_bar_right.value)

func set_crosshair(value: Texture2D) -> void:
	%Crosshair.texture = value
