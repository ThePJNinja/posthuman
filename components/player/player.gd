extends CharacterBody3D

signal MenuOn
signal MenuOff

@export var StartingWeapon: Weapons
@export var Default_FOV := 90.0

@export_category("Movement")
@export var Jump_Strength := 4.5
@export var SprintSpeed := 20.0
@export var WalkSpeed := 5.0
@export var Acceleration := 10.0
@export var Friction := 50.0
@export var AirAccelMultiplier := 2.0
var Speed: float
@export var NewGravityDir := Vector3.DOWN
@export var NewGravityStr := 9.8
@onready var NewGravity := NewGravityDir.normalized() * NewGravityStr
var Gravity: Vector3
@export var SensX100k := 200.0
var Sensitivity: float

@export_category("Status")
@export var SetMaxHealth := 100.0
@export var SetHealth := 100.0
var MaxHealth: float
var Health: float

@onready var Hud := %Hud as CanvasLayer
@onready var Pivot_Y := %PivotY as Node3D
@onready var Pivot_X := %PivotY/PivotX as Node3D
@onready var Eye := %PivotY/PivotX/Eye as Camera3D
@onready var ProjectileStartPoint := %"PivotY/PivotX/Eye/Projectile Start Point" as Marker3D

func _ready() -> void:
	print(get_gravity())
	activate()

func activate() -> void:
	
	# Set Camera
	Eye.make_current()
	Hud.show()
	
	# Set Health Values
	set_health_and_max(SetHealth, SetMaxHealth)
	
	# Set Gravity
	var original_gravity := get_gravity()
	Gravity = NewGravity
	
	# Modify Sensitivity
	Sensitivity = SensX100k/100000
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event: InputEvent) -> void:
	# Mouse control
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		look(event as InputEventMouseMotion)

func look(look_dir: InputEventMouseMotion) -> void:
	%PivotY.rotate_y(-look_dir.relative.x * Sensitivity)
	%PivotX.rotate_x(-look_dir.relative.y * Sensitivity)
	var PXRotation := (%PivotX as Node3D).rotation
	PXRotation.x = clamp(PXRotation.x, -PI/2, PI/2)
	%PivotX.rotation = PXRotation

func _process(_delta: float) -> void:
	pass
	#var prevFov = Eye.fov
	#var aimFov = clampf(Default_FOV + velocity.length(), 1.0, 180)
	#var nuFovAdd = clampf(aimFov - prevFov, -0.1, 0.1);
	#Eye.fov += pow(nuFovAdd, 2)w

func _physics_process(delta: float) -> void:
	# Rotate towards gravity
	up_direction = -Gravity.normalized()
	var position2 := position
	look_at_from_position(Vector3.ZERO, up_direction)
	position = position2
	
	# Handle Sprint
	Speed = WalkSpeed if Input.is_action_pressed("Walk") else SprintSpeed
	
	var direction := Vector3.ZERO
	direction += Pivot_Y.global_transform.basis.z * Input.get_axis("Move Fowards", "Move Backwards")
	direction += Pivot_Y.global_transform.basis.x * Input.get_axis("Move Left", "Move Right")
	direction = direction.normalized()
	
	# Ground Movement
	if is_on_floor():
		# Todo: add handle crouch to floor and air
		
		if direction and is_processing_input():
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
			velocity += Jump_Strength*up_direction
	
	# Air Movement. Strafing!
	else:
		if is_processing_input():
			var add_speed = Speed - velocity.dot(direction)
			
			if add_speed > 0:
				var accel_speed = velocity.length() * AirAccelMultiplier * delta
				if (accel_speed > add_speed):
					accel_speed = add_speed
				velocity += accel_speed * direction
		
		# Add the gravity.
		velocity += Gravity * delta
	
	move_and_slide()

func set_health(value: float) -> void:
	set_health_and_max(value, MaxHealth)

func set_health_and_max(value: float, max_value: float) -> void:
	Health = value
	MaxHealth = max_value
	Hud.set_health(value, max_value)

func menu_on() -> void:
	Hud.hide()
	MenuOn.emit()

func menu_off() -> void:
	Hud.show()
	MenuOff.emit()
