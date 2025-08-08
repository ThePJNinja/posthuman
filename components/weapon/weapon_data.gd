class_name WeaponData extends Resource
@export_category("Data")
@export var name: StringName
@export_range(0.0, 4.29497e+09, 0.01, "exp") var damage := 10.0
@export_range(0.0, 10.0, 0.01, "exp") var refire_time := 1.0
@export_category("Orientation")
@export var position: Vector3
@export var rotation: Vector3
@export_category("Visual")
@export var mesh: Mesh
@export var crosshair: Texture2D
@export_range(5.0, 120.0, 0.5, "exp") var zoom_fov := 30.0 
@export_subgroup("Weapon Sway")
@export_custom(PROPERTY_HINT_LINK, "") var sway_min := Vector2(-20.0, -20.0)
@export_custom(PROPERTY_HINT_LINK, "") var sway_max := Vector2(20.0, 20.0)
@export_range(0.0,0.2,0.01) var sway_speed_position := 0.07
@export_range(0.0,0.2,0.01) var sway_speed_rotation := 0.1
@export_range(0.0,0.5,0.01) var sway_amount_position := 0.1
@export_range(0.0,50.0,0.1) var sway_amount_rotation := 30.0
