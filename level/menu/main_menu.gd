extends MenuLayer

func _ready() -> void:
	MenuName = "Main Menu"
	
	%Resume.connect("button_up", resume)
	%"New Game".connect("button_up", new_game)
	%"Load Game".connect("button_up", load_game)
	%Options.connect("button_up", options)
	%"Test Map".connect("button_up", test_map)
	%Quit.connect("button_up", quit)

func resume() -> void:
	pass

func new_game() -> void:
	pass

func load_game() -> void:
	pass

func options() -> void:
	go_to_menu(get_child_menu("Options"))

func test_map() -> void:
	pass

func quit() -> void:
	pass
