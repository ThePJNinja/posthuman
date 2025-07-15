extends Node

var MenuDepth := Array

@onready var Menus := %MenuItems.get_children() as Array[Control]
var Level: Node3D
var Player: CharacterBody3D
var _SceneTree := SceneTree.new()

@export var StartingMap: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%Resume.connect("button_up", menu_off)
	%"Testing Map".connect("button_up", testing_map)
	
	menu_on()

func _input(event: InputEvent) -> void:
	if event is InputEventAction:
		var action = event as InputEventAction
		if action.is_action("Menu"):
			if MenuToggle:
				
			else:
				

func testing_map() -> void:
	load_level(load("res://level/testing/DevPlayground.tscn").instantiate())

func load_level(node: Node3D) -> void:
	if Level:
		remove_child(Level)
	
	Level = node
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
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
