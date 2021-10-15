# Ball is a KinematicBody2D so we can use the physics engine to
#   detect collisions and manipulate its velocity.  It's not
#   otherwise controlled by the physics engine.
extends KinematicBody2D

# The ball's current velocity.  This is a vector as the ball can
#   be moving along the X and Y axes simultaneously.
var velocity : = Vector2.ZERO

#-----------------------------------------------------------------
const POINTER_COLOR  : = Color( 1.0, 0.0, 0.0, 1.0 )
const POINTER_RADIUS : = 2.5
const LINE_COLOR     : = Color( 0.5, 0.5, 0.5, 1.0 )

#-----------------------------------------------------------------
# Called when we enter the tree ...
func _ready() -> void :
# warning-ignore:return_value_discarded
  Signals.connect("Exit_edit_mode", self, "exitEditMode" )

#-----------------------------------------------------------------
# Called when we have to redraw the ball's velocity vector.
#   (The call to _update() in _physics_process() schedules this.)
func _draw() -> void :
  # The velocity vector is drawn only when we're in edit mode.
  if not Globals.gameIsPaused : return

  # Draw a line representing the velocity vector and stick a
  #   circle on the end.
  draw_line( Vector2.ZERO, velocity, LINE_COLOR )
  draw_circle( velocity, POINTER_RADIUS, POINTER_COLOR )

#-----------------------------------------------------------------
# On each frame ...
func _physics_process( delta : float ) -> void :
  # We do not update the ball when in pause mode.
  if Globals.gameIsPaused :
    # Cause the ball's velocity vector to be redrawn.
    update()

    # We don't do anything else for the ball while in edit mode.
    return

  # Move according to our current velocity for the current time
  #   slice "delta".
  # The return value from move_and_collide() tells us whether or
  #   not we hit something while we were moving.
  var collide = move_and_collide( velocity * delta )

  # Did we collide?  "collide" is null if we didn't.
  if collide :
    # Our new velocity is our old velocity "bounced" off of what-
    #   ever it was we hit.  The angle of our new velocity is
    #   reflected according to the normal of the collision.
    #   (Isn't it convenient that Godot automatically calculates
    #   the surface normal of the collision and has great
    #   functions such as "bounce" to do the reflection math for
    #   us? :)
    velocity = velocity.bounce( collide.normal )

    # We hit something.  Let's print a message to the debug
    #   console giving some pertinent information about this
    #   collision.
    print( "%7.3f: %s has hit %s. New velocity %s, mag %.3f." % [
      OS.get_ticks_msec() / 1000.0, name, collide.collider.name,
      str( velocity ), velocity.length() ] )

    # Part of the collision is how much of the original movement
    #   was NOT done because we hit whatever we hit: that's the
    #   "remainder".  We "bounce" this also off of the struck
    #   surface so the remaining movement will be in the correct
    #   direction.
    var remainder = collide.remainder.bounce( collide.normal )

    # Now that the remaining movement has been "bounced", actually
    #   do it.  (Hmm, we're throwing any collision from *this*
    #   movement away.  Is that OK?)
# warning-ignore:return_value_discarded
    move_and_collide( remainder )

#-----------------------------------------------------------------
# Gets called when the ball leaves the screen ...
func _on_VisibilityNotifier2D_screen_exited() -> void :
  # Print a nifty message in the debug console.
  print( "%7.3f: %s has left the screen." % [ OS.get_ticks_msec() / 1000.0, name ] )

  # It's possible that the level is already over by the time the
  #   ball leaves the screen:  after all, the ball could have hit
  #   and removed the last target earlier.
  if not Globals.levelHasAlreadyEnded :
    # The level was NOT already ended, so let everyone know that
    #   the level is well and truly ended now.
    Signals.emit_signal( "Level_has_ended", "The ball has left the playing field!" )

  # We're off the screen, so we go invisible with no velocity.
  #   (We'll get deleted and replaced when a level starts.)
  visible = false
  velocity = Vector2.ZERO

#-----------------------------------------------------------------
func exitEditMode() -> void :
  # When we exit edit mode, we need to "undraw" the velocity
  #   vector.  We do this by scheduling an update and then do
  #   nothing in that update.
  update()

#-----------------------------------------------------------------
func getVelocity() -> Vector2 :
  return velocity

func moveWhenSelected( delta : Vector2 ) -> void :
  # We're OK with being moved around when in edit mode.
  position += delta

#-----------------------------------------------------------------
# This function is called when we're supposed to start on the
#   Playing Field.
func start( startPos : Vector2, startVel : Vector2 ) -> void :
  # Move ourselves to whatever position at which we were told to
  #   start.
  position = startPos

  # The ball's initial velocity.
  velocity = startVel

  # Spiffy message for the debug console ...
  print( "%7.3f: %s has started at %s with velocity %s, mag %.3f." % [
    OS.get_ticks_msec() / 1000.0, name,
    str( position ), str( velocity ), velocity.length() ] )

#-----------------------------------------------------------------
