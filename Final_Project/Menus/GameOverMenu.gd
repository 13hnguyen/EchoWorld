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

  if (nxtlvl  == 1) :
    var _scene = get_tree().change_scene("res://Level/Level1.tscn")
    print("reloading level ", nxtlvl)
  elif (nxtlvl == 2) :
    print("level 2 is not created yet")
    #var _scene = get_tree().change_scene("res://Level/Level2.tscn")
    #print("reloading level ", nxtlvl)
  elif (nxtlvl == 3) :
    print("level 3 is not created yet")
    #var _scene = get_tree().change_scene("res://Level/Level3.tscn")
    #print("reloading level ", nxtlvl)
  elif (nxtlvl == 4) :
    print("level 4 is not created yet")
    #var _scene = get_tree().change_scene("res://Level/Level4.tscn")
    #print("reloading level ", nxtlvl)
  elif (nxtlvl == 5) :
    print("level 5 is not created yet")
    #var _scene = get_tree().change_scene("res://Level/Level5.tscn")
    #print("reloading level ", nxtlvl)
  else :
    # if the savePlayerObj.level is null, then the player is a new player on level 0
    var _scene = get_tree().change_scene("res://Level/Level.tscn")
    print("reloading level ", nxtlvl)

###############################################################################################################
