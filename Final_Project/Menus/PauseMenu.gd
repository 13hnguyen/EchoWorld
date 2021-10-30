extends Node2D

# function to handle input event for pausing during level
func _input(event: InputEvent) -> void:
  if event.is_action_pressed( "ui_pause" ) :
    get_tree().paused = not get_tree().paused
    visible = not visible

# function to handle "continue" clicked on pause menu. resume play on level
func _on_Continue_pressed() -> void:
  print("continuing game")
  get_tree().paused = not get_tree().paused
  visible = not visible

# function to handle "quit" clicked on pause menu. changes to main menu
func _on_Quit_pressed() -> void:
  print("quitting game. return to main menu")
  get_tree().paused = not get_tree().paused
  var _scene = get_tree().change_scene("res://Menus/MainMenu.tscn")
