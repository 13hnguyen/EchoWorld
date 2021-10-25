extends Area2D

# Which level am I the portal for?
export var whichLevel : = 0

# The only body that could possibly enter this area is the
#   Player (why is that so?).  All we have to do is tell the
#   Player to go to the next level.
func _on_Portal_body_entered( body : PhysicsBody2D ) -> void :
  print( "Player entered the Portal for level %d." % [ whichLevel ] )

  # When the portal on a level is entered by the player, we tell
  #   the player to go to the next level, which is our level
  #   number plus 1.
  body.gotoLevel( whichLevel + 1 )
