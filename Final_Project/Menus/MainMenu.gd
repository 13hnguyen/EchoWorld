extends Node2D

# function to start the background music playing.
func _ready() -> void :
  $MenuMusic.play()

# function to popup player creation from main menu when clicked "new game"
func _on_NewGame_pressed() -> void:
  print("new game menu")
  get_node("MenuOptions/NewGame/PlayerCreation").popup()

# function when the player clicks "OK" from dialog menu to create new player and load level
func _on_PlayerCreation_confirmed() -> void:
  var playerName = find_node("PlayerNameCreate").text.strip_edges()
  if playerName.empty():
    print("No name entered. Defaulting to John Doe")
    playerName = "John Doe"
  print("player name entered from new game: " + playerName)
  GameData.saveNewPlayer(playerName)
  var _scene = get_tree().change_scene("res://Level/Level.tscn")
  print("player created. starting level")

# function to fill in player names for dropdown when clicked "load game"
func _on_LoadGame_pressed() -> void:
  print("load game menu")
  $MenuOptions/LoadGame/LoadPlayer/PlayerList.clear()
  get_node("MenuOptions/LoadGame/LoadPlayer").popup()
  #print(GameData.data)
  for n in GameData.data[0].players:
    #print("n = ",n)
    #print(n.name)
    $MenuOptions/LoadGame/LoadPlayer/PlayerList.add_item("Player: " + n.name,load("res://Art/Players/rover.png"),true)

func _on_PlayerList_item_activated(index: int) -> void:
  #print(index)
  get_node("MenuOptions/LoadGame/LoadPlayer").hide()
  print("player selected to load")
  GameData.loadPlayer(index)

# function to popup player deletion from main menu when click "delete game"
func _on_DeleteGame_pressed() -> void:
  print("delete game menu")
  get_node("MenuOptions/DeleteGame/PlayerDeletion").popup()

func _on_PlayerDeletion_confirmed() -> void:
  var deleteName = find_node("PlayerNameDelete").text.strip_edges()
  if deleteName.empty():
    print("No name entered. Cannot delete player without a name")
    deleteName = ""
  else :
    print("player name entered to delete: " + deleteName)
    GameData.deletePlayer(deleteName)

# function to show movement controls from main menu when clicked "controls"
func _on_Controls_pressed() -> void:
  print("game controls menu")
  get_node("MenuOptions/Controls/PlayerControls").popup()

# function to quit the game from main menu when clicked "quit"
func _on_Quit_pressed() -> void:
  get_tree().quit( 0 )
