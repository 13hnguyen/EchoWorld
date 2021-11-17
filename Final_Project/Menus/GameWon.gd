extends Node2D

func _on_MainMenu_pressed() -> void:
  print("returning to main menu")
  var _scene = get_tree().change_scene("res://Menus/MainMenu.tscn")
