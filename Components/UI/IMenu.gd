extends Control
class_name IMenu

signal exit_menu
signal confirm_changes
signal switch_menu(index: int)

func emit_exit_menu():
	exit_menu.emit()
