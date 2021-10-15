#-----------------------------------------------------------------
# The Player is a KinematicBody2D so that it can register
#   collisions, but NOT be affected by the physics engine.  That
#   is, we control the movement of the Player ourselves by
#   getting motion commands from the user.
extends KinematicBody2D

#-----------------------------------------------------------------
# The "linear" velocity of the player.  No matter which direction
#   the player is moving, if it's moving at all, it moves at this
#   (linear) speed.
var speed : = 750.0

#-----------------------------------------------------------------
# Called once per frame ...
func _physics_process( _delta : float ) -> void :
  if Globals.gameIsPaused :
    return

  # Check the input actions and determine the direction of the
  #   player's movement.  It's normalized so AS LONG AS THERE IS
  #   ANY MOTION AT ALL, the length of the vector will be 1.0.
  # Godot conveniently makes any zero length vector normalize to
  #   length 0.
  var direction : = Vector2(
    Input.get_action_strength( "move_right") - Input.get_action_strength( "move_left" ),
    Input.get_action_strength( "move_down") - Input.get_action_strength( "move_up" )
    ).normalized()

  # Move us at our appropriate speed in the requested direction.
  #   If the direction is ZERO, we don't move at all.
  # We use move_and_slide() so if we hit something, our motion
  #   slides along whatever we hit.
  # We ignore the return value from move_and_slide() as we don't
  #   care whether we hit anything or not.  We recompute the
  #   direction of movement every frame (see above).
# warning-ignore:return_value_discarded
  move_and_slide( speed * direction )

#-----------------------------------------------------------------
func moveWhenSelected( delta : Vector2 ) -> void :
  # In edit mode, we're OK with being moved around.
  position += delta

#-----------------------------------------------------------------
