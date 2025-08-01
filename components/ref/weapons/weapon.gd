class_name Weapon extends Node3D

@export var id: StringName
@export var screen_name: String
@export var mesh_node: MeshInstance3D
@export var crosshair: Texture2D
@export var attack: PackedScene:
	set(v):
		attack = v 
		# Check root node here?

func _ready() -> void:
	pass

func fire(start_point: Node3D) -> void:
	var attack_inst = attack.instantiate()
	assert(attack_inst is WeaponAttack, "\"" + id + "\"'s attack scene root node must be an Attack.")
	attack_inst._attack1(start_point)
