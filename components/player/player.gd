extends CharacterBody3D

var menu := false
signal MenuOn
signal MenuOff

@export var StartingWeapon: Weapons
@export var FOV := 90.0

@export_category("Movement")
@export var JumpVelocity := 4.5
@export var SprintSpeed := 20.0
@export var WalkSpeed := 5.0
@export var Acceleration := 10.0
@export var Friction := 50.0
@export var AirAccelMultiplier := 2.0
var Speed: float
@export var NewGravityStrength := 9.8
@export var OverrideGravity := false
var Gravity: Vector3
@export var SensX100k := 200.0
var Sensitivity: float

@export_category("Status")
@export var SetMaxHealth := 100.0
@export var SetHealth := 100.0
var MaxHealth: float
var Health: float

@onready var Hud := %Hud
@onready var Pivot := %Pivot
@onready var Eye := %Pivot/Eye
@onready var ProjectileStartPoint := %"Pivot/Eye/Projectile Start Point"

func _ready() -> void:
	activate()

func activate() -> void:
	
	# Set Camera
	Eye.make_current()
	Hud.show()
	
	# Set Health Values
	set_health_and_max(SetHealth, SetMaxHealth)
	
	# Set Gravity
	var original_gravity = get_gravity()
	if OverrideGravity:
		Gravity = original_gravity.normalized() * NewGravityStrength
	else:
		Gravity = original_gravity
	
	# Modify Sensitivity
	Sensitivity = SensX100k/100000
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event: InputEvent) -> void:
	# Mouse control
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		var mouseMotion := event as InputEventMouseMotion
		Pivot.rotate_y(-mouseMotion.relative.x * Sensitivity)
		Eye.rotate_x(-mouseMotion.relative.y * Sensitivity)
		var eyeRotation: Vector3 = Eye.rotation
		eyeRotation.x = clamp(eyeRotation.x, -PI/2, PI/2)
		Eye.rotation = eyeRotation

func _process(_delta: float) -> void:
	set_health_and_max(Health, MaxHealth)
	
	if Input.is_action_just_pressed("Menu"):
		if menu:
			menu_off()
		else:
			menu_on()
		menu = !menu
	
	#var prevFov = Eye.fov
	#var aimFov = clampf(FOV + velocity.length(), 1.0, 180)
	#var nuFovAdd = clampf(aimFov - prevFov, -0.1, 0.1);
	#Eye.fov += pow(nuFovAdd, 2)w

func _physics_process(delta: float) -> void:
	# Handle Sprint
	Speed = WalkSpeed if Input.is_action_pressed("Walk") else SprintSpeed
	
	# Get the input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector("Move Left", "Move Right", "Move Fowards", "Move Backwards")
	input_dir = input_dir.rotated(-Pivot.rotation.y)
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	# Ground Movement
	if is_on_floor():
		# Todo: add handle crouch to floor and air
		
		if direction:
			velocity += direction * (Acceleration * delta)
			var velfric := velocity + direction * (Friction * delta)
			if velocity.length() > Speed:
				velocity *= Speed/velocity.length()
			if velfric.length() < velocity.length():
				#print("Friction!!!!") # Used to test the extra effect from trying to slow down
				velocity = velfric
		else:
			if velocity.length() > 0.5:
				velocity -= velocity.normalized() * (Friction * delta)
			else:
				velocity = Vector3.ZERO
		
		# Handle jump.
		if Input.is_action_pressed("Jump"):
			velocity.y = JumpVelocity
	
	# Air Movement. Strafing!
	else:
		# Add the gravity.
		velocity += get_gravity() * delta
		
		var add_speed = Speed - velocity.dot(direction)
		
		if add_speed > 0:
			var accel_speed = velocity.length() * AirAccelMultiplier * delta
			if (accel_speed > add_speed):
				accel_speed = add_speed
			velocity += accel_speed * direction
	
	move_and_slide()

func set_health(value: float) -> void:
	set_health_and_max(value, MaxHealth)

func set_health_and_max(value: float, max_value: float) -> void:
	Health = value
	MaxHealth = max_value
	Hud.set_health(value, max_value)

func menu_on() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	print("Menu on")
	Hud.hide()
	MenuOn.emit()

func menu_off() -> void:
	MenuOff.emit()
