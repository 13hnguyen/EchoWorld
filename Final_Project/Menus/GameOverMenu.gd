extends Node2D

###############################################################################################################
# function for the button that takes the player back to the main menu

func _on_BackToMainMenu_pressed() -> void:
  print("Returning to main menu")
  var _scene = get_tree().change_scene("res://Menus/MainMenu.tscn")
  
###############################################################################################################




###############################################################################################################
# function for the button that takes the player back to the current level

func _on_TryAgain_pressed() -> void:
  print("Player is trying again")
  var nxtlvl = GameData.savePlayerObj.level
  print("reloading level ", nxtlvl)

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
  else :
    var _scene = get_tree().change_scene("res://Level/Level0.tscn")

###############################################################################################################
