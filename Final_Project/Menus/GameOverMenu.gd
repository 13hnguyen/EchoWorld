extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# func for the button that takes the player back to the main menu
func _on_BackToMainMenu_pressed() -> void:
  print("Returning to main menu")
  var _scene = get_tree().change_scene("res://Menus/MainMenu.tscn")

# func for the button that takes the player back to the level
func _on_TryAgain_pressed() -> void:
  print("Player is trying again")
  var _scene = get_tree().change_scene("res://Level/Level.tscn")
