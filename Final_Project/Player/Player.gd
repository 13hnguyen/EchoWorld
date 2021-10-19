# The Player object is a kinematic body so it can be subject to
#   collisions.  We move it manually with move_and_slide().
extends KinematicBody2D

# "gravity" is an acceleration:  it's that many units
#   per second per second.  It's positive because "down" on the
#   screen is the POSITIVE Y axis direction.
var gravity  : = 3000.0

# "speed.x" is how fast the player moves when directed along the X
#   axis with LEFT and RIGHT.  "speed.y" is how fact the player
#   moves UP when directed to JUMP.
var speed    : = Vector2( 300.0, 1250.0 )

# "stompImpulse" is how fast we start moving up after we stomp an
#   enemy.  It's our 'bounce'.
var stompImpluse : = 800.0

# "velocity" is how fast the player is moving along the X and Y
#   axes at present.  (It starts at ZERO since the player is
#   initially not moving.)
var velocity : = Vector2.ZERO

# "_physics_process" is called once per frame at the frame rate.
#   On entry, its "delta" parameter is exactly how many seconds
#   it's been since the last call.
func _physics_process( delta : float ) -> void :
  # If the player is in the middle of a jump (the Y velocity is
  #   less than zero, indicating the player is moving UP on the
  #   screen) and the user lets go of the JUMP key (detected using
  #   is_action_just_released()), we want to stop the jump and
  #   start falling again.
  var isJumpInterrupted : = Input.is_action_just_released("jump") and velocity.y < 0.0

  # "direction.x" is which way the player is moving along the X
  #   axis, if any at all.  When LEFT and RIGHT are from the
  #   keyboard, direction.x will be exactly 1 (moving right),
  #   exactly -1 (moving left), or exactly 0 (not moving along
  #   the X axis at all).
  #   When LEFT and RIGHT are from a controller stick, direction.x
  #   will be a FLOAT value in the range [-1, 1] indicating the
  #   strength of the movement along the X axis.  Again, 0 means
  #   no movement along the X axis at all.

  # "direction.y" is 1 when the player is falling.  Remember, the
  #   positive Y axis is DOWN along the screen.  direction.y is
  #   -1 when the player has just started a JUMP.
  var direction : = Vector2(
    Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
    -1 if Input.is_action_just_pressed("jump") and is_on_floor() else 1
   )

  # Whichever way we going along the X axis, our speed is that
  #   direction times speed.x
  velocity.x = speed.x * direction.x

  # If we have just interrupted our jump, we instantly stop
  #   moving either up or down.  Our Y axis velocity is ZERO.
  if isJumpInterrupted :
    velocity.y = 0.0

  elif direction.y == -1 :
    # On the other hand, if we have just JUMPed, our Y axis
    #   velocity is whatever our JUMP speed is in the UP
    #   direction.  Remember, a jump means moving UP on the
    #   screen and that's the NEGATIVE Y direction.
    velocity.y = -speed.y

  else :
    # Otherwise, by default our Y axis velocity accelerates by
    #   however much gravity has worked on us since the last
    #   frame.  "delta" is the number of seconds since the last
    #   frame.  "gravity" is units per second per second.
    #   Multiplying the two gives us the amount that our falling
    #   speed has increased since the last frame so we add it in.
    velocity.y += gravity * delta

  # Now that we know what our velocity is, we tell Godot to move
  #   us at that speed (in the X and Y directions).  The
  #   move_and_slide() function takes "delta" into account
  #   automatically so we will move just how much we are supposed
  #   to since the time of the last frame.

  # move_and_slide() also takes into account collisions.  It will
  #   detect if we have run into anything else (e.g., the ground)
  #   and ensure that we don't overrun anything we shouldn't.
  #   To inform us that happened, move_and_slide() returns a
  #   possibly adjusted velocity indicating whether we were
  #   stopped by a collision.  We use that updated info to change
  #   our version of velocity so we don't, e.g., keep trying to
  #   move DOWN on the screen after we've hit the floor.
  velocity = move_and_slide( velocity, Vector2.UP )

# When a body enters the collision region associated with the
#   EnemyDetector.
func _on_EnemyDetector_body_entered( _body : Node ) -> void :
  print( "Player got hit by an Enemy." )

  # A body has collided with the EnemyDetector.  (The only body
  #   this could POSSIBLY be is an enemy.)

  # We got hit.  We send ourselves back to the beginning of this
  #   level.  (The default for gotoLevel() is to stay on the same
  #   level.)
  gotoLevel()

# When a body enters the collision region associated with the
#   StompDetector.
func _on_StompDetector_body_entered( _body : Node ) -> void :
  # A body has collided with the StompDetector.  (The only body
  #   this could POSSIBLY be is an enemy.  Why is that so?)

  # We stomped an enemy.  We get a bounce up because of this.
  velocity.y = -stompImpluse

#-----------------------------------------------------------------
# All the info re: the "levels".
#   The levels are all in the same scene, but we keep the sections
#   separate.  When a player hits the portal belonging to one
#   level, it appears at the start position in the next level.
#   When a player is hit by an enemy, it appears at the start
#   position in the same level.

const level = [
  { 'StartPosition' : Vector2(  163, 181 ), 'CameraLimits' : [  -64, 3984 ] },
  { 'StartPosition' : Vector2( 4288, 181 ), 'CameraLimits' : [ 3904, 7952 ] }
  ]

# Which level is the player currently on.
var currentLevel : = 0

# Move the player (and camera) to the indicated level.
#   If the requested level is < 0, we just go to the start
#   position on the current leve.
#   If the requested level is greated than the number of levels,
#   we just go to the first level.
func gotoLevel( which : int = -1 ) -> void :
  if which < 0 :
    which = currentLevel

  if which >= level.size() :
    print( "Finished last level, so going back to the beginning." )
    which = 0

  # "Going to" a level means setting the Player to the start
  #   position on that level and setting the left and right limits
  #   of the camera view to the range that the level encompasses.
  position = level[which][ 'StartPosition' ]
  $Camera2D.limit_left  = level[which][ 'CameraLimits' ][0]
  $Camera2D.limit_right = level[which][ 'CameraLimits' ][1]

#-----------------------------------------------------------------
