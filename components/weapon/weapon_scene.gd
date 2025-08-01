@tool
extends Node3D

signal crosshair(value: Texture2D)

@export var weapon_arr: Array[WeaponData]
@export var c_weapon: WeaponData:
	set(v):
		c_weapon = v
		# See changes in editor
		if Engine.is_editor_hint(): load_weapon()

var base_position: Vector3
@onready var pivot := %Pivot as Node3D
@onready var mesh_instance := %Pivot/WeaponMesh as MeshInstance3D

func _ready() -> void:
	load_weapon()

func load_weapon() -> void:
	mesh_instance.mesh = c_weapon.mesh as Mesh
	mesh_instance.rotation.x = deg_to_rad(c_weapon.rotation.x as float)
	mesh_instance.rotation.y = deg_to_rad(c_weapon.rotation.y as float)
	mesh_instance.rotation.z = deg_to_rad(c_weapon.rotation.z as float)
	base_position = c_weapon.position as Vector3
	pivot.position = base_position
	crosshair.emit(c_weapon.crosshair)

func face(global_point: Vector3) -> void:
	# Do not run before _ready()!!!
	#var angle := (-pivot.global_transform.basis.z).angle_to(global_point-pivot.global_position)
	#var dist2 := pivot.global_position.distance_squared_to(global_point)
	#print(dist2)
	#if dist2 > pow(0.5, 2):
		#pivot.look_at(global_point, global_transform.basis.y.normalized())
		#return
	#reset_rotation()
	pivot.position = base_position
	pivot.look_at(global_point, global_transform.basis.y.normalized())
	if Vector3.RIGHT.angle_to(pivot.transform.basis.x) > PI/4:
		pivot.rotation = Vector3(PI/2.0, 0.0, 0.0)
		pivot.translate(Vector3.BACK * 0.3)

func reset_rotation() -> void:
	pivot.rotation = Vector3.ZERO
