class_name WeaponAttack extends Node3D

#enum attack_type {
	#BEAM,		# Deals damage every couple of tics in contact with beam projectiles
	#HITSCAN,	# Attacks By a scan of the crosshair position
	#MELEE,		# Hitscan with limited range
	#PROJECTILE	# Shoots projectiles that damage upon contact
#}
#const BEAM = attack_type.BEAM
#const HITSCAN = attack_type.HITSCAN
#const MELEE = attack_type.MELEE
#const PROJECTILE = attack_type.PROJECTILE

@export var id: StringName
@export_category("Effect")
@export_range(0.1, 2147483647.0, 0.1, "or_less", "exp") var damage := 10.0

func _attack1(start_point: Node3D) -> void: pass
