extends Node3D

signal crosshair
signal attack

@export var WEAPON_RES : Weapons

@onready var mesh: MeshInstance3D = %Mesh

func _ready() -> void:
	mesh.mesh = WEAPON_RES.mesh
	position = WEAPON_RES.position
	rotation_degrees = WEAPON_RES.rotation
