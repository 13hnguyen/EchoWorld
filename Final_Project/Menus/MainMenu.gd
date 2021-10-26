extends Node2D

# function to load first level from main menu when clicked "new game"
func _on_NewGame_pressed() -> void:
  var _scene = get_tree().change_scene("res://Level/Level.tscn")

# function to quit the game from main menu when clicked "quit"
func _on_Quit_pressed() -> void:
  get_tree().quit( 0 )
