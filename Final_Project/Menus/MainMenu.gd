extends Node2D

# function to start the background music playing.
func _ready() -> void :
  $MenuMusic.play()

# function to popup player creation from main menu when clicked "new game"
func _on_NewGame_pressed() -> void:
  print("creating new player")
  get_node("MenuOptions/NewGame/PlayerCreation").popup()

# function when the player clicks "OK" from dialog menu to create new player and load level
func _on_PlayerCreation_confirmed() -> void:
  print("player created. starting level")
  var _scene = get_tree().change_scene("res://Level/Level.tscn")

# function to fill in player names for dropdown when clicked "load game"
func _on_LoadGame_pressed() -> void:
  print("load game pressed")
  $MenuOptions/LoadGame.get_popup().clear() # remove previous popup items
  #print(GameData.data)
  for n in GameData.data[0].players:
    #print("n = ",n)
    #print(n.name)
    $MenuOptions/LoadGame.get_popup().add_item("Player: " + n.name)

# function to show movement controls from main menu when clicked "controls"
func _on_Controls_pressed() -> void:
  print("movement controls displaying")
  get_node("MenuOptions/Controls/PlayerControls").popup()

# function to quit the game from main menu when clicked "quit"
func _on_Quit_pressed() -> void:
  get_tree().quit( 0 )
