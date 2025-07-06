extends CharacterBody3D

# Movement variables
@export var JumpVelocity := 4.5
@export var SprintSpeed := 20.0
@export var WalkSpeed := 5.0
@export var Acceleration := 10.0
@export var Friction := 50.0
@export var SensX100k := 200.0
@export var AirAccelMultiplier := 2.0
@export var StartingGunScene: PackedScene
@export var NewGravityStrength := 9.8
@export var OverrideGravity := false

# Status variables
@export var SetMaxHealth := 100.0
@export var SetHealth := 100.0
var MaxHealth := 100
var Health := 100
var Hud: CanvasLayer


var StartTime: int
var Speed: float
var Gravity: Vector3
var Sensitivity: float
var Pivot: Node3D
var Eye: Camera3D
var Hand: Skeleton3D
# var CurrWeapon: Weapon
var ProjectileStartPoint: Marker3D

func _ready() -> void:
	StartTime = Time.get_unix_time_from_system()
	
	# Set Gravity
	var original_gravity = get_gravity()
	if OverrideGravity:
		Gravity = original_gravity.normalized() * NewGravityStrength
	else:
		Gravity = original_gravity
	
	# Modify Sensitivity
	Sensitivity = SensX100k/100000
	
	# Add Node Pointers
	Hand = $"Pivot/Eye/Weapon Rig/Hand"
	# TODO: Add gun as child of hand
	Pivot =					$Pivot
	Eye = 					$Pivot/Eye
	ProjectileStartPoint =	$"Pivot/Eye/Projectile Start Point"
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	

func _input(event: InputEvent) -> void:
	# Mouse control
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		var mouseMotion := event as InputEventMouseMotion
		Pivot.rotate_y(-mouseMotion.relative.x * Sensitivity)
		Eye.rotate_x(-mouseMotion.relative.y * Sensitivity)
		var eyeRotation := Eye.rotation
		eyeRotation.x = clamp(eyeRotation.x, -PI/2, PI/2)
		Eye.rotation = eyeRotation

func _process(delta: float) -> void:
	set_health_max(SetMaxHealth)
	set_health(SetHealth)
	if (int(Time.get_unix_time_from_system()) % 1000 == 0):
		$Hud/Velocity/value.text = str(velocity.length())
		print(velocity.length())
	if Input.is_action_just_pressed("Menu"):
		if (Input.mouse_mode == Input.MOUSE_MODE_CAPTURED):
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		elif (Input.mouse_mode == Input.MOUSE_MODE_VISIBLE):
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

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
				velocity = velfric
		else:
			if velocity.length() > 0.3:
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

func set_health_max(value: float) -> void:
	MaxHealth = value
	$"Hud/Health Bar/HealthLeft".max_value = value
	$"Hud/Health Bar/HealthRight".max_value = value 

func set_health(value: float) -> void:
	Health = value
	$"Hud/Health Bar/HealthLeft".set_value(value)
	$"Hud/Health Bar/HealthRight".set_value(value)
	$"Hud/Health Bar/HealthLabel".text = str(value) + "/" + str(MaxHealth)
