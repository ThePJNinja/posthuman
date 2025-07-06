extends Node3D

@export var WEAPON_RES : Weapons

@onready var mesh: MeshInstance3D = %WeaponMesh


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$".".add_child(mesh)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
