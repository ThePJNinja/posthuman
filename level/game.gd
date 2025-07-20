extends Node

# Menus
var Menu_Toggle := true
var Curr_Menu: Menu
var Menus: Array[Menu] = []

# Game
var Level: Node3D
var Players: Array[CharacterBody3D] = []
var Curr_Player: CharacterBody3D
var Local: bool								# If game is running locally

@export var Starting_Map: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Curr_Menu = %MenuItems/MainMenu
	Curr_Menu.connect("Add_Menu", add_menu)
	Curr_Menu.connect("Set_Menu", set_menu)
	Curr_Menu.connect("Menu_Off", menu_off)
	Curr_Menu.connect("Load_Level", load_level)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Menu"):
		if %MenuItems.visible:
			Curr_Menu.back()
		else:
			menu_on()

func menu_on() -> void:
	%MenuItems.show()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE 
	# Pause
	if Curr_Player:
		Curr_Player.set_process_input(false)

func menu_off() -> void:
	%MenuItems.hide()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	# Unpause
	if Curr_Player:
		Curr_Player.set_process_input(true)

func add_menu(menu: Menu) -> void: 
	Menus.append(menu)

func set_menu(menu: Menu) -> void:
	# Remove Signals
	Curr_Menu.disconnect("Add_Menu", add_menu)
	Curr_Menu.disconnect("Set_Menu", set_menu)
	Curr_Menu.disconnect("Menu_Off", menu_off)
	Curr_Menu.disconnect("Load_Level", load_level)
	# Set Menu
	Curr_Menu = menu
	# Add Signals
	Curr_Menu.connect("Add_Menu", add_menu)
	Curr_Menu.connect("Set_Menu", set_menu)
	Curr_Menu.connect("Menu_Off", menu_off)
	Curr_Menu.connect("Load_Level", load_level)

func load_level(level: PackedScene) -> void:
	set_level(level.instantiate())

func set_level(node: Node3D) -> void:
	if Level:
		remove_child(Level)
		Level.queue_free()
	
	Level = node
	Curr_Player = Level.get_node("Player") as CharacterBody3D
	add_child(Level)
	set_menu(%MenuItems/MainMenu)
	menu_off()
