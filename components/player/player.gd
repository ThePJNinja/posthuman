class_name Player extends CharacterBody3D

signal MenuOn
signal MenuOff

@export var default_fov := 90.0

@export_category("Nodes")
@export var HUD: CanvasLayer
@export var COLLIDER: CollisionShape3D
@export var PIVOT_Y: Node3D
@export var PIVOT_X: Node3D
@export var EYE: Camera3D
@export var WEAPON: Node3D
@export var PROJECTILE_START_POINT: Marker3D
@export var ANIMATION_PLAYER: AnimationPlayer
@export var SHAPE_CAST: ShapeCast3D
@export var SLIDE_TIMER: Timer

@export_category("Movement")
@export var SPRINT_SPEED := 20.0
@export var WALK_SPEED := 5.0
@export var JUMP_STRENGTH := 4.5
@export var ACCELERATION := 10.0
@export var FRICTION := 50.0
@export var AIR_ACCELERATION_MULTIPLIER := 1.0
@export var SENS_X_100K := 200.0

var speed: float
var gravity: Vector3
var sensitivity: float
var is_crouching := false
var set_crouching := false

@export_category("Status")
@export var SET_MAX_HEALTH := 100.0
@export var SET_HEALTH := 100.0
@onready var max_health: float:
	set(v):
		max_health = v
		HUD.set_health(v)
@onready var health: float:
	set(v):
		health = v
		HUD.set_health_max(v)

func _ready() -> void:
	Global.player = self
	
	gravity = get_gravity()
	health = SET_HEALTH
	max_health = SET_MAX_HEALTH
	
	# Set Camera
	EYE.make_current()
	#HUD.show()
	
	# Set Gravity
	#gravity = NewGravity
	
	# Modify sensitivity
	sensitivity = SENS_X_100K/100000
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event: InputEvent) -> void:
	# Mouse control
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		look(event as InputEventMouseMotion)

func look(look_dir: InputEventMouseMotion) -> void:
	PIVOT_Y.rotate_y(-look_dir.relative.x * sensitivity)
	PIVOT_X.rotate_x(-look_dir.relative.y * sensitivity)
	var PXRotation := PIVOT_X.rotation
	PXRotation.x = clamp(PXRotation.x, -PI/2, PI/2)
	PIVOT_X.rotation = PXRotation

func _process(_delta: float) -> void:
	var center := get_viewport().size / 2 as Vector2i
	var origin := EYE.project_ray_origin(center)
	var end := origin + EYE.project_ray_normal(center) * 1000
	var query := PhysicsRayQueryParameters3D.create(origin, end)
	var result := EYE.get_world_3d().direct_space_state.intersect_ray(query)
	
	# I think this is bugged -v
	WEAPON.face(result.get("position", end))
	
	if is_processing_input() and Input.is_action_just_pressed("Attack"):
		pass#WEAPON.fire(PROJECTILE_START_POINT)

func _physics_process(delta: float) -> void:
	rotate_to_gravity()
	move_via_input(delta)
	crouch()
	
	move_and_slide()

func crouch() -> void:
	if Input.is_action_just_pressed("Crouch (Hold)"):
		set_crouching = true
	elif Input.is_action_just_released("Crouch (Hold)"):
		set_crouching = false
	elif Input.is_action_just_pressed("Crouch (Toggle)"):
		set_crouching = !set_crouching
	
	if set_crouching == is_crouching: return
	
	if set_crouching:
		ANIMATION_PLAYER.play("Crouch", -1, 3, false)
	elif !SHAPE_CAST.is_colliding(): 
		ANIMATION_PLAYER.play("Crouch", -1, -3, true)

func _on_animation_player_animation_started(anim_name: StringName) -> void:
	if anim_name == "Crouch":
		is_crouching = !is_crouching

func rotate_to_gravity() -> void:
	if gravity == get_gravity(): return
	gravity = get_gravity()
	if gravity == Vector3.ZERO:
		gravity = Vector3(0.0, -9.8, 0.0)
	
	var angle: float
	var axis: Vector3
	up_direction = -gravity.normalized()
	
	angle = Vector3.DOWN.angle_to(gravity.normalized())
	axis = Vector3.DOWN.cross(gravity.normalized()).normalized()
	global_rotation = Vector3.ZERO
	if axis != Vector3.ZERO: global_rotate(
		axis,
		angle
	)

func move_via_input(delta: float) -> void:
	var direction := Vector3.ZERO
	direction += PIVOT_Y.global_transform.basis.z * Input.get_axis("Move Fowards", "Move Backwards")
	direction += PIVOT_Y.global_transform.basis.x * Input.get_axis("Move Left", "Move Right")
	direction = direction.normalized()
	
	# Handle Sprint
	speed = WALK_SPEED if Input.is_action_pressed("Walk") or is_crouching else SPRINT_SPEED
	
	# Ground Movement
	if is_on_floor():
		# Todo: add handle crouch to floor and air
		
		if direction and is_processing_input():
			var velaccel := velocity + direction * (ACCELERATION * delta)
			var velfric := velocity + direction * (FRICTION * delta)
			if velfric.length() < velocity.length():
				#print("FRICTION!!!!") # Used to test the extra effect from trying to slow down
				velocity = velfric
			elif velaccel.length() < speed:
				velocity = velaccel
		else:
			if velocity.length() > 0.5:
				velocity -= velocity.normalized() * (FRICTION * delta)
			else:
				velocity = Vector3.ZERO
		
		# Handle jump.
		if Input.is_action_pressed("Jump") and !(ANIMATION_PLAYER.current_animation == "Crouch" and ANIMATION_PLAYER.is_playing()):
			velocity += JUMP_STRENGTH * up_direction
	
	# Air Movement. Strafing!
	else:
		if is_processing_input():
			var add_speed = SPRINT_SPEED - velocity.dot(direction)
			
			if add_speed > 0:
				var accel_speed = velocity.length() * AIR_ACCELERATION_MULTIPLIER * delta
				if (accel_speed > add_speed):
					accel_speed = add_speed
				velocity += accel_speed * direction
		
		# Add the gravity.
		velocity += gravity * 0.75 * delta if Input.is_action_pressed("Jump") else gravity * delta

func menu_on() -> void:
	HUD.hide()
	MenuOn.emit()

func menu_off() -> void:
	HUD.show()
	MenuOff.emit()
