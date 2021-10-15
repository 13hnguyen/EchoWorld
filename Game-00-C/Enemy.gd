# The Enemy object is a kinematic body so it can be subject to
#   collisions.  We move it manually with move_and_slide().
extends KinematicBody2D

# "gravity" is an acceleration:  it's that many units
#   per second per second.  It's positive because "down" on the
#   screen is the POSITIVE Y axis direction.
var gravity  : = 3000.0

# "speed.x" is how fast the enemy moves when moving along the X
#   axis.  Enemies don't JUMP (at least not in this version :)
#   so "speed.y" isn't used.  Yet.  :)
var speed    : = Vector2( 150.0, 1250.0 )

# "velocity" is how fast the enemy is moving along the X and Y
#   axes at present.  (It starts at ZERO since the enemy is
#   initially not moving.)
var velocity : = Vector2.ZERO

# The "_ready()" function is executed ONCE when the enemy object
#   is inserted in the scene tree.
func _ready() -> void:
  # When the enemy is inserted in the tree, we start it moving to
  #   the left at its default speed.
  velocity.x = -speed.x

# "_physics_process" is called once per frame at the frame rate.
#   On entry, its "delta" parameter is exactly how many seconds
#   it's been since the last call.
func _physics_process(delta: float) -> void:
  # Enemies fall accord to gravity until they hit the floor.
  velocity.y += gravity * delta

  # We move the enemy using the computed velocity using the
  #   move_and_slide() function.  We update the Y component of
  #   the velocity according to what move_and_slide() tells us
  #   since it may have detected we've hit a floor so we shouldn't
  #   fall any longer.

  # We do NOT use the x component of the velocity returned by
  #   move_and_slide() since we detect hitting a wall sideways
  #   ourselves below.
  velocity.y = move_and_slide( velocity, Vector2.UP ).y

  # move_and_slide() computes whether we've had a collision
  #   sideways and makes that info available to us through the
  #   is_on_wall() function, which will be true in that case.

  # If we hit a wall, we want to ricochet so whenever we're on
  #   a wall, we multiply our X velocity by -1 so we instantly
  #   start moving in the opposite direction.
  velocity.x *= -1 if is_on_wall() else 1

# A "..._body_entered" function is called whenever a body enters
#   the collision region associated with the area.  (Use the
#   Node > Signals tab to "connect" the signal to the function.)
func _on_StompDetector_body_entered( body : Node ) -> void :
  # A body has collided with the StompDetector.  (The only body
  #   this could POSSIBLY be is the player.  Why?  Check the
  #   Layer / Mask settings.)

  # If the body came in from the top (i.e., the body's Y location
  #   is LESS than the detector's Y location), that means the
  #   stomp came from above.
  if body.global_position.y < $StompDetector.global_position.y :
    print( "Enemy got stomped by the Player." )

    # OK, it was from above, so that means this enemy got stomped.
    #   We need to remove the enemy.  We do that with the
    #   queue_free() function because deleting ourselves instantly
    #   can cause bad references to exist.  queue_free() causes
    #   us to be deleted at the END of the frame, when it's safe
    #   to do so.
    queue_free()
