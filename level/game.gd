extends Node

# menus
var menu_toggle := true
var curr_menu: Menu
var menus: Array[Menu] = []

# Game
var LEVEL: Node3D
var local: bool								# If game is running locally

@export var Starting_Map: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	curr_menu = %MenuItems/MainMenu
	curr_menu.connect("Add_Menu", add_menu)
	curr_menu.connect("Set_Menu", set_menu)
	curr_menu.connect("Menu_Off", menu_off)
	curr_menu.connect("Load_Level", load_level)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_menu"):
		if %MenuItems.visible:
			curr_menu.back()
		else:
			menu_on()

func menu_on() -> void:
	%MenuItems.show()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE 
	# Pause
	if Global.player:
		Global.player.set_process_input(false)
		LEVEL.set_physics_process(false)

func menu_off() -> void:
	%MenuItems.hide()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	# Unpause
	if Global.player:
		Global.player.set_process_input(true)
		LEVEL.set_physics_process(true)

func add_menu(menu: Menu) -> void: 
	menus.append(menu)

func set_menu(menu: Menu) -> void:
	# Remove Signals
	curr_menu.disconnect("Add_Menu", add_menu)
	curr_menu.disconnect("Set_Menu", set_menu)
	curr_menu.disconnect("Menu_Off", menu_off)
	curr_menu.disconnect("Load_Level", load_level)
	# Set Menu
	curr_menu = menu
	# Add Signals
	curr_menu.connect("Add_Menu", add_menu)
	curr_menu.connect("Set_Menu", set_menu)
	curr_menu.connect("Menu_Off", menu_off)
	curr_menu.connect("Load_Level", load_level)

func load_level(level: PackedScene) -> void:
	set_level(level.instantiate())

func set_level(node: Node3D) -> void:
	if LEVEL:
		LEVEL.queue_free()
		remove_child(LEVEL)
	
	LEVEL = node
	#await node.ready
	add_child(LEVEL)
	set_menu(%MenuItems/MainMenu)
	menu_off()
