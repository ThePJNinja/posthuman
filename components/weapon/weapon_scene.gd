@tool
class_name WeaponScene extends Node3D

signal crosshair(value: Texture2D)

@export var WEAPON_ARR: Array[WeaponData]
@export var C_WEAPON: WeaponData:
	set(v):
		C_WEAPON = v
		# See changes in editor
		if Engine.is_editor_hint(): load_weapon()

@export var pivot: Node3D
@export var pivot_b: Node3D
@export var mesh_instance: MeshInstance3D

var mouse_movement := Vector2.ZERO
var facing_this_point: Vector3

func _ready() -> void:
	load_weapon()

func load_weapon() -> void:
	mesh_instance.mesh = C_WEAPON.mesh as Mesh
	mesh_instance.rotation_degrees = C_WEAPON.rotation
	pivot.position = C_WEAPON.position
	if Engine.is_editor_hint(): return
	crosshair.emit(C_WEAPON.crosshair)

func face(delta: float) -> void:
	if Engine.is_editor_hint(): return
	var point := facing_this_point
	if !facing_this_point: point = (1000 * -global_transform.basis.z) + global_position
	
	var fowards := -pivot_b.global_transform.basis.z.normalized()
	var towards := pivot_b.global_position.direction_to(point)
	
	var axis := fowards.cross(towards).normalized()
	var angle := fowards.angle_to(towards)
	
	pivot_b.global_rotate(axis, lerp_angle(0, angle, minf(delta, 1.0)))
	pivot_b.rotation.z = 0.0
	#pivot.look_at(global_point, global_transform.basis.y.normalized())

func sway(delta: float):
	mouse_movement = mouse_movement.clamp(C_WEAPON.sway_min, C_WEAPON.sway_max)
	pivot.position.x = lerp(pivot.position.x, C_WEAPON.position.x - (mouse_movement.x * C_WEAPON.sway_amount_position) * delta, C_WEAPON.sway_speed_position)
	pivot.position.y = lerp(pivot.position.y, C_WEAPON.position.y + (mouse_movement.y * C_WEAPON.sway_amount_position) * delta, C_WEAPON.sway_speed_position)
	
	mesh_instance.rotation_degrees.y = lerp(mesh_instance.rotation_degrees.y, C_WEAPON.rotation.y + (mouse_movement.x * C_WEAPON.sway_amount_rotation) * delta, C_WEAPON.sway_speed_rotation)
	mesh_instance.rotation_degrees.x = lerp(mesh_instance.rotation_degrees.x, C_WEAPON.rotation.x - (mouse_movement.y * C_WEAPON.sway_amount_rotation) * delta, C_WEAPON.sway_speed_rotation)

func reset_rotation() -> void:
	pivot.rotation = Vector3.ZERO

func _physics_process(delta: float) -> void:
	face(delta)
	sway(delta)
