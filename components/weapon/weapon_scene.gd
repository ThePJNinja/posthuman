@tool
class_name WeaponScene extends Node3D

signal crosshair(value: Texture2D)

@export var WEAPON_ARR: Array[WeaponData]
@export var C_WEAPON: WeaponData:
	set(v):
		C_WEAPON = v
		# See changes in editor
		if Engine.is_editor_hint(): load_weapon()

@export var PIVOT: Node3D
@export var RECOIL_PIVOT: Node3D
@export var MESH_INSTANCE: MeshInstance3D
@export var AUDIO_PLAYER: AudioStreamPlayer3D
@export var ANIMATION_PLAYER: AnimationPlayer

var raycast_test := preload("res://components/weapon/raycast_test.tscn")

var mouse_movement := Vector2.ZERO
var facing_this_point: Vector3
var x_rot := 0.0

var weapon_ready := true:
	set(v):
		weapon_ready = v
		if v: return
		await get_tree().create_timer(C_WEAPON.refire_time).timeout
		weapon_ready = true

func load_weapon() -> void:
	if !Engine.is_editor_hint(): await ready
	MESH_INSTANCE.mesh = C_WEAPON.mesh as Mesh
	MESH_INSTANCE.rotation_degrees = C_WEAPON.rotation
	PIVOT.position = C_WEAPON.position
	if Engine.is_editor_hint(): return
	crosshair.emit(C_WEAPON.crosshair)

func attack() -> void:
	if !weapon_ready: return
	weapon_ready = false
	var instance := raycast_test.instantiate() as MeshInstance3D
	instance.top_level = true
	add_child(instance)
	instance.global_position = facing_this_point
	ANIMATION_PLAYER.play("Recoil", -1, (1 / C_WEAPON.refire_time) + 0.1)
	AUDIO_PLAYER.pitch_scale = remap(randf(), 0, 1, 0.8, 1.2)
	AUDIO_PLAYER.play()
	await get_tree().create_timer(3.0).timeout
	instance.queue_free()

func recoil() -> void:
	pass

func face(delta: float) -> void:
	var point := facing_this_point
	if !facing_this_point: point = (1000 * -global_transform.basis.z) + global_position
	
	var fowards := -PIVOT.global_transform.basis.z.normalized()
	var towards := PIVOT.global_position.direction_to(point)
	
	var axis := fowards.cross(towards).normalized()
	var angle := fowards.angle_to(towards)
	
	PIVOT.global_rotate(axis, lerp_angle(0, angle, minf(delta, 1.0)))
	PIVOT.rotation.z = 0.0

func sway(delta: float) -> void:
	if Engine.is_editor_hint(): return
	mouse_movement = mouse_movement.clamp(C_WEAPON.sway_min, C_WEAPON.sway_max)
	PIVOT.position.x = lerpf(PIVOT.position.x, C_WEAPON.position.x - mouse_movement.x * C_WEAPON.sway_amount_position * delta, C_WEAPON.sway_speed_position)
	PIVOT.position.y = lerpf(PIVOT.position.y, C_WEAPON.position.y + mouse_movement.y * C_WEAPON.sway_amount_position * delta, C_WEAPON.sway_speed_position)
	PIVOT.position.z = lerpf(PIVOT.position.z, C_WEAPON.position.z + x_rot * 0.125, C_WEAPON.sway_speed_position)
	
	MESH_INSTANCE.rotation_degrees.y = lerpf(MESH_INSTANCE.rotation_degrees.y, C_WEAPON.rotation.y + (mouse_movement.x * C_WEAPON.sway_amount_rotation) * delta, C_WEAPON.sway_speed_rotation)
	MESH_INSTANCE.rotation_degrees.x = lerpf(MESH_INSTANCE.rotation_degrees.x, C_WEAPON.rotation.x - (mouse_movement.y * C_WEAPON.sway_amount_rotation) * delta, C_WEAPON.sway_speed_rotation)

func reset_rotation() -> void:
	PIVOT.rotation = Vector3.ZERO

func _ready() -> void:
	load_weapon()

func _physics_process(delta: float) -> void:
	face(delta)
	sway(delta)
