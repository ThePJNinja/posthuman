class_name Player extends CharacterBody3D

signal MenuOn
signal MenuOff

@export var default_fov := 90.0

@export_category("Nodes")
@export var HUD: CanvasLayer
@export var PIVOT_Y: Node3D
@export var PIVOT_X: Node3D
@export var EYE: Camera3D
@export var WEAPON: WeaponScene
@export var PROJECTILE_START_POINT: Marker3D
@export var ANIMATION_PLAYER: AnimationPlayer
@export var SHAPE_CAST: ShapeCast3D
@export var SLIDE_TIMER: Timer

@export_category("Movement")
var speed := 7.0
var acceleration := 2.0
var friction := 3.0
@export var JUMP_STRENGTH := 4.5
@export var AIR_ACCELERATION_MULTIPLIER := 1.0
@export var SENS_X_100K := 200.0

var gravity: Vector3
var sensitivity: float
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
	#HUD.show()
	
	# Set Gravity
	#gravity = NewGravity
	
	# Modify sensitivity
	sensitivity = SENS_X_100K/100000
	
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
	PIVOT_X.rotation.x = clamp(PIVOT_X.rotation.x, -PI/2, PI/2)

func _process(_delta: float) -> void:
	
	if is_processing_input() and Input.is_action_just_pressed("Attack"):
		pass#WEAPON.fire(PROJECTILE_START_POINT)

func _physics_process(delta: float) -> void:
	point_weapon()

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
	var center := get_viewport().size / 2 as Vector2i
	var origin := EYE.project_ray_origin(center)
	var end := origin + EYE.project_ray_normal(center) * 1000
	var query := PhysicsRayQueryParameters3D.create(origin, end)
	var result = EYE.get_world_3d().direct_space_state.intersect_ray(query).get("position")
	if result == null:
		WEAPON.facing_this_point = (1000 * -EYE.global_transform.basis.z) + EYE.global_position
		return
	WEAPON.facing_this_point = result

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
