extends Menu

func _ready() -> void:
	MenuName = "Main Menu"
	
	%Resume.connect("button_up", resume)
	%"New Game".connect("button_up", new_game)
	%"Load Game".connect("button_up", load_game)
	%Options.connect("button_up", options)
	%"Test Map".connect("button_up", test_map)
	%Quit.connect("button_up", quit)

## BUTTONS

func resume() -> void:
	back()

func new_game() -> void:
	pass

func load_game() -> void:
	pass

func options() -> void:
	set_menu_to_child("Options")

func test_map() -> void:
	Load_Level.emit(load("res://level/testing/DevPlayground.tscn"))

func quit() -> void:
	pass
