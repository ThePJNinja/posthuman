class_name Weapons extends Resource

enum weapon_type {
	HITSCAN,	# Attacks By a scan of the crosshair position
	MELEE,		# Hitscan with limited range
	BEAM,		# Deals damage every couple of tics in contact with beam projectiles
	PROJECTILE	# Shoots projectiles that damage upon contact
}

@export var name: StringName
@export_category("Function")
@export var type: weapon_type
@export var projectile: Projectile
@export_category("Position")
@export var position: Vector3
@export var rotation: Vector3
@export_category("Visual")
@export var mesh: Mesh
@export var crosshair: Texture
