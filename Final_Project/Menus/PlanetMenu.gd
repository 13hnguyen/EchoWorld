extends Node2D

# update the next level that the player will be playing on the planet transition menu
func _ready() -> void:
  var lvl = get_node("LevelNumber")
  var nxtlvl = GameData.savePlayerObj.level
  lvl.set_text(str("Next Planet: ", nxtlvl))

# function to return to main menu from planet transition menu
func _on_ReturnMainMenu_pressed() -> void:
  print("returning to main menu")
  var _scene = get_tree().change_scene("res://Menus/MainMenu.tscn")

# function to load next level when player clicks 'continue' from planet transition menu
func _on_Continue_pressed() -> void:
  var nxtlvl = GameData.savePlayerObj.level
  print("loading level ", nxtlvl)

  if (nxtlvl  == 1) :
    print("level 1 is not created yet")
    #var _scene = get_tree().change_scene("res://Level/Level1.tscn")
  elif (nxtlvl == 2) :
    print("level 2 is not created yet")
    #var _scene = get_tree().change_scene("res://Level/Level2.tscn")
  elif (nxtlvl == 3) :
    print("level 3 is not created yet")
    #var _scene = get_tree().change_scene("res://Level/Level3.tscn")
  elif (nxtlvl == 4) :
    print("level 4 is not created yet")
    #var _scene = get_tree().change_scene("res://Level/Level4.tscn")
  elif (nxtlvl == 5) :
    print("level 5 is not created yet")
    #var _scene = get_tree().change_scene("res://Level/Level5.tscn")
