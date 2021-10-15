# A target is an Area2D because all we care about is whether the
#   ball runs over us.  If so, we're "collected" and we disappear.
#   We don't have "collisions" in the physics sense so we don't
#   need to be a Physics Body of any kind.
extends Area2D

# The sprite of a target come from an "atlas";  that is, a texture
#   that has multiple pictures in it.  Which picture is used is
#   based on which region of the atlas we select.  (See below for
#   how this is computed.)
var TARGET_ATLAS = preload( "res://Scenes/Target/Target-1-3-7-120x40.png" )

# The target sprite dimensions.
const WIDTH  : = 40
const HEIGHT : = 40

# Possible target values.  These have to be in ascending order (so
#   incrWhenSelected() will work properly) and in the same order
#   the sprites are in the TARGET_ATLAS.
const POSSIBLE_VALUES : = [ 1, 3, 7 ]

# How much our target is worth.
export var value : = 1

#-----------------------------------------------------------------
# Called when the Target is added to the tree ...
func _ready() -> void :
  # Keep a running total of how many targets there are on the
  #   current Playing Field.  This makes it easy to detect when
  #   the last target is deleted.
  Globals.howManyTargets += 1

#-----------------------------------------------------------------
# Called by whoever instantiates this target to supply the
#   target's (x, y) position on the screen and the value of the
#   target.
func init( myVal : int, x : float, y : float ) -> void :
  # Position ourselves on the screen.
  position = Vector2( x, y )

  # We make a new texture for each target so each can be of a
  #   different region.
  $Sprite.set_texture( AtlasTexture.new() )
  $Sprite.texture.set_atlas( TARGET_ATLAS )

  # The sprite associated with this target is based on its value.
  var which : = POSSIBLE_VALUES.find( myVal )

  if which == -1 :
    # Oops!  Unknown value.  Default to 1.
    print( "Target value %d not understood.  Defaulting to 1." % [ value ] )
    myVal = 1
    which = 0

  # Remember how much we're worth.
  value = myVal

  # The position and size of the sprite associated with this
  #   target.
  setSprite( which )

func setSprite( which : int ) -> void :
  # Set our displayed sprite to match our value.
  var region : = Rect2( which*WIDTH, 0, WIDTH, HEIGHT )

  $Sprite.texture.set_region( region )

#-----------------------------------------------------------------
# Called when this Target is entered ...
func _on_Target_body_entered( body : Node ) -> void :
  if Globals.gameIsPaused :
    return

  # The ball hit us.

  # Tell the HUD to increment the score by whatever our value is.
  Signals.emit_signal( "Incr_score", value )

  # We got hit so we're going to be gone.  If we were the last
  #   target, the level is now over.  Emit the appropriate signal
  #   if that's happened.
  Globals.howManyTargets -= 1
  if Globals.howManyTargets == 0 :
    Signals.emit_signal( "Level_has_ended", "You hit the last target!" )

  # Useful message for the debug console ...
  print( "%7.3f: %s has hit target %s (%d point%s). %d target%s left." % [
    OS.get_ticks_msec()/1000.0, body.name, name,
    value, "" if value == 1 else "s",
    Globals.howManyTargets, "" if Globals.howManyTargets == 1 else "s" ] )

  # We now delete ourselves using queue_free().
  queue_free()

#-----------------------------------------------------------------
func deleteWhenSelected() -> void :
  # We're OK with being deleted by the user in edit mode.

  # We have to decrement the count of currently existing targets
  #   so when this level is unpaused the count is OK.
  Globals.howManyTargets -= 1

  # Delete ourselves.
  queue_free()

func getState() -> Array :
  # The information that's kept about us in a level description.
  return [ value, position[0], position[1] ]

func incrWhenSelected( incr : int ) -> void :
  # We're OK with being "incremented" by the user when we're in
  #   edit mode.

  # Ensure incr is +1, 0, or -1 depending on its sign.
  incr = +1 if incr > 0 else -1 if incr < 0 else 0

  # Get the index of our current value in the POSSIBLE_VALUES
  #   list.  Add incr to that index.  Ensure the result is a
  #   legal index by clamping it at 0 on the bottom and size-1
  #   on the top.  (Why-o-why doesn't GDScript have an iclamp()?)
  var index : = int( clamp(
    POSSIBLE_VALUES.find( value ) + incr,
    0, POSSIBLE_VALUES.size()-1 ) )

  # Get the value of the new index as our new value.
  value = POSSIBLE_VALUES[ index ]

  # Set our displayed sprite to match our (possibly) new value.
  setSprite( index )

func moveWhenSelected( delta : Vector2 ) -> void :
  # We're OK with being moved by the user in edit mode.
  position += delta

#-----------------------------------------------------------------
