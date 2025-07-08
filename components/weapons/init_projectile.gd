extends RigidBody3D

@export var PROJ_RES: Projectile

@onready var mesh: MeshInstance3D

func _ready() -> void:
	mesh.mesh = PROJ_RES.mesh
