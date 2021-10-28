extends Node2D

# function to start the background music playing.
func _ready() -> void :
  $MenuMusic.play()

# function to load first level from main menu when clicked "new game"
func _on_NewGame_pressed() -> void:
  print("starting new game")
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

func _on_Controls_pressed() -> void:
  $MenuOptions/Controls.get_popup().clear() # remove previous popup items
  $MenuOptions/Controls.get_popup().add_item("Move: WASD")
  $MenuOptions/Controls.get_popup().add_item("Shoot: F (right), G (up)")

# function to quit the game from main menu when clicked "quit"
func _on_Quit_pressed() -> void:
  get_tree().quit( 0 )
