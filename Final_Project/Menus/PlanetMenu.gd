extends Node2D

# update the next level that the player will be playing on the planet transition menu
func _ready() -> void:
  var nxtlvl = GameData.savePlayerObj.level
  if (nxtlvl != 6) :
    var lvl = get_node("LevelNumber")
    lvl.set_text(str("Next Planet: ", GameData.planetNames[nxtlvl]))
  else :
    var _scene = get_tree().change_scene("res://Menus/GameWon.tscn")

# function to return to main menu from planet transition menu
func _on_ReturnMainMenu_pressed() -> void:
  print("returning to main menu")
  var _scene = get_tree().change_scene("res://Menus/MainMenu.tscn")

# function to load next level when player clicks 'continue' from planet transition menu
func _on_Continue_pressed() -> void:
  var nxtlvl = GameData.savePlayerObj.level
  print("loading level ", GameData.planetNames[nxtlvl])

  if (nxtlvl  == 1) :
    var _scene = get_tree().change_scene("res://Level/Level1.tscn")
  elif (nxtlvl == 2) :
    var _scene = get_tree().change_scene("res://Level/Level2.tscn")
  elif (nxtlvl == 3) :
    var _scene = get_tree().change_scene("res://Level/Level3.tscn")
  elif (nxtlvl == 4) :
    var _scene = get_tree().change_scene("res://Level/Level4.tscn")
  elif (nxtlvl == 5) :
    var _scene = get_tree().change_scene("res://Level/Level5.tscn")
