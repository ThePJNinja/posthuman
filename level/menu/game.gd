extends Node

var Menus: Array[Control]
var Level: Node3D
var Player: CharacterBody3D
var _SceneTree := SceneTree.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%Resume.connect("button_up", menu_off)
	%"Testing Map".connect("button_up", testing_map)
	
	Menus = %MenuItems.get_children() as Array[Control]
	
	print(_SceneTree.get_current_scene())
	
	menu_on()

func testing_map() -> void:
	load_level("res://level/testing/DevPlayground.tscn")

func load_level(path: StringName) -> void:
	if Level:
		remove_child(Level)
	
	Level = load(path).instantiate()
	Player = Level.get_node("Player")
	Player.connect("MenuOn", menu_on)
	Player.connect("MenuOff", menu_off)
	add_child(Level)
	menu_off()

func menu_off() -> void:
	%MenuItems.hide()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func menu_on() -> void:
	%MenuItems.show()
	if Level and Player:
		%Resume.show()
	else:
		%Resume.hide()
