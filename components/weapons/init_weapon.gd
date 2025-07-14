extends Node3D

signal attack

@export var WEAPON_RES : Weapons

@onready var mesh := %Mesh
@onready var crosshair: Texture

func _ready() -> void:
	mesh.mesh = WEAPON_RES.mesh
	
	crosshair = WEAPON_RES.crosshair
	
	position = WEAPON_RES.position
	rotation_degrees = WEAPON_RES.rotation
