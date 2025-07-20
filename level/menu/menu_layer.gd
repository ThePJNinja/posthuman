class_name Menu extends Control

signal Add_Menu
signal Set_Menu
signal Menu_Off
signal Load_Level

@export var MenuName: StringName
@export var SetChildMenus: Array[PackedScene]
var ChildMenus: Array[Menu]
var PrevMenu: Menu

func _ready() -> void:
	add_menus(SetChildMenus)

func add_menus(menus: Array[PackedScene]) -> void:
	for menu in menus:
		add_menu(menu)

func add_menu(packed_menu: PackedScene) -> void:
	var menu := packed_menu.instantiate() as Menu
	Add_Menu.emit(menu)
	ChildMenus.append(menu)
	$"..".add_child(menu)
	menu.hide()

func set_prev(new_parent: Menu) -> void:
	PrevMenu = new_parent

func set_menu(menu: Menu, do_set_prev := true) -> void:
	Set_Menu.emit(menu)
	menu.show()
	hide()
	if do_set_prev: menu.set_prev($".")

func get_child_menu(menu_name: StringName) -> Menu:
	for i in ChildMenus:
		if i.MenuName == menu_name:
			return i
	return

func set_menu_to_child(menu_name: StringName) -> void:
	set_menu(get_child_menu(menu_name))

func back() -> void:
	if PrevMenu:
		set_menu(PrevMenu, false)
		print("Back!")
	else:
		Menu_Off.emit()
		print("Menu off...")
