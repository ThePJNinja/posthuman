class_name Projectile extends WeaponAttack

@export var rigid_body: RigidBody3D
@export var mesh: MeshInstance3D
var default_mesh_rotation: Vector3
@export_range(0.2, 100.0, 0.2, "suffix:m/s") var speed: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rigid_body.collision_layer = 2
	rigid_body.collision_mask = 5
	rigid_body.contact_monitor = true
	rigid_body.max_contacts_reported = 8
	default_mesh_rotation = mesh.global_rotation

func _process(_delta: float) -> void:
	var angle := Vector3.FORWARD.angle_to(rigid_body.linear_velocity)
	var cross := Vector3.FORWARD.cross(rigid_body.linear_velocity)
	mesh.global_rotation = default_mesh_rotation.rotated(cross, angle)

func _physics_process(_delta: float) -> void:
	var collisions := rigid_body.get_colliding_bodies()
	if collisions.size() > 1:
		for i in collisions:
			if i is CharacterBody3D:
				print("Hit!!!")
				break
		queue_free()

func _attack1(start_point: Node3D) -> void:
	rigid_body.global_position = start_point.global_position
	rigid_body.global_rotation = start_point.global_rotation
	
	rigid_body.linear_velocity = rigid_body.global_transform.basis.x * speed
