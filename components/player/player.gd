class_name Player extends CharacterBody3D

signal MenuOn
signal MenuOff

@export var default_fov := 90.0

@export_category("Nodes")
@export var HUD: CanvasLayer
@export var PIVOT_Y: Node3D
@export var PIVOT_X: Node3D
@export var EYE: Camera3D:
	set(v):
		EYE = v
		DEFAULT_FOV = v.fov
@export var WEAPON: WeaponScene
@export var PROJECTILE_START_POINT: Marker3D
@export var HIT_SCAN: RayCast3D
@export var INTERACTION_SCAN: RayCast3D
@export var ANIMATION_PLAYER: AnimationPlayer
@export var SLIDE_TIMER: Timer
var DEFAULT_FOV: float

@export_category("Movement")
var speed := 7.0
var acceleration := 2.0
var friction := 3.0
@export var JUMP_STRENGTH := 4.5
@export var AIR_ACCELERATION_MULTIPLIER := 1.0
@export var SENS_X_100K := 200.0:
	set(v):
		SENS_X_100K = v
		sensitivity = v/100000

var gravity: Vector3
var sensitivity := SENS_X_100K/100000
#var is_crouching := false
#var set_crouching := false

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
	HUD.show()
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event: InputEvent) -> void:
	# Mouse control
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		var mouse_movement := (event as InputEventMouseMotion).relative
		if !mouse_movement: return
		look(mouse_movement)
		WEAPON.mouse_movement = mouse_movement as Vector2

func look(look_dir: Vector2) -> void:
	PIVOT_Y.rotate_y(-look_dir.x * sensitivity)
	PIVOT_X.rotate_x(-look_dir.y * sensitivity)
	PIVOT_X.rotation_degrees.x = clampf(PIVOT_X.rotation_degrees.x, -90, 90)
	WEAPON.x_rot = PIVOT_X.rotation_degrees.x / 90

func _physics_process(delta: float) -> void:
	point_weapon()
	var zoom_speed := 3.0
	if Input.is_action_pressed("Attack"): WEAPON.attack()
	if Input.is_action_pressed("Zoom"):
		EYE.fov = lerpf(EYE.fov, WEAPON.C_WEAPON.zoom_fov, clampf(zoom_speed * delta, 0.0, 1.0))
	elif EYE.fov != DEFAULT_FOV:
		EYE.fov = lerpf(EYE.fov, DEFAULT_FOV, clampf(zoom_speed * delta, 0.0, 1.0))

func rotate_to_gravity() -> void:
	var gravity2 = get_gravity()
	if gravity == gravity2: return
	gravity = gravity2
	if gravity == Vector3.ZERO:
		gravity = Vector3(0.0, -9.8, 0.0)
	
	var axis := Vector3.DOWN.cross(gravity.normalized()).normalized()
	var angle := Vector3.DOWN.angle_to(gravity.normalized())
	up_direction = -gravity.normalized()
	
	global_rotation = Vector3.ZERO
	if axis != Vector3.ZERO: global_rotate(axis, angle)
	#print(global_rotation_degrees)

func point_weapon() -> void:
	if HIT_SCAN.is_colliding():
		WEAPON.facing_this_point = HIT_SCAN.get_collision_point()
	else:
		WEAPON.facing_this_point = (1000 * -HIT_SCAN.global_transform.basis.z) + HIT_SCAN.global_position

func get_horisontal_direction() -> Vector3:
	var direction := Vector3.ZERO
	if is_processing_input():
		direction += PIVOT_Y.global_transform.basis.z * Input.get_axis("Move Fowards", "Move Backwards")
		direction += PIVOT_Y.global_transform.basis.x * Input.get_axis("Move Left", "Move Right")
		direction = direction.normalized()
	return direction

func apply_gravity(delta: float, multiplier := 1.0) -> void:
	velocity += gravity * multiplier * delta

func menu_on() -> void:
	HUD.hide()
	MenuOn.emit()

func menu_off() -> void:
	HUD.show()
	MenuOff.emit()
