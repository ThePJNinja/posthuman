class_name MenuLayer extends CanvasLayer

signal HideMenu
signal ChangeMenu

@export var MenuName: StringName
var PrevMenu: MenuLayer
@export var SetChildMenus: Array[PackedScene]
var ChildMenus: Array[MenuLayer]

func _ready() -> void:
	for i in SetChildMenus:
		var i2 := i.instantiate() as MenuLayer
		ChildMenus.append(i2)
		$"..".add_child(i2)
		i2.hide()

func set_prev(new_parent: MenuLayer) -> void:
	PrevMenu = new_parent

func go_to_menu(menu: MenuLayer) -> void:
	menu.show()
	menu.set_prev($".")
	hide()

func get_child_menu(name: StringName) -> MenuLayer:
	for i in ChildMenus:
		if i.MenuName == name:
			return i
	return null

func back() -> void:
	if PrevMenu:
		ChangeMenu.emit(PrevMenu)
	else:
		HideMenu.emit()
