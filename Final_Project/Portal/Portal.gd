extends Area2D

# function to tell the player to go to the next level
func _on_Portal_body_entered( body : PhysicsBody2D ) -> void :
  var lvl = GameData.savePlayerObj.level
  if (lvl != 0) : # if player was on any other level (1 - 5)
    print( "Player entered the Portal for level %d." % [ GameData.savePlayerObj.level ] )
    if body.is_in_group("player") :
      body.gotoScene( lvl + 1 )
  else : # if player was on the base level 0
    print( "Player entered the Portal for level 0.")
    if body.is_in_group("player") :
      body.gotoScene( 1 )
