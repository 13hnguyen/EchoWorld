# A bumper is a StaticBody2D because while it needs to be able to
#   participate in collisions, it doesn't care about them.  That
#   is, the bumper is not moved around or otherwise affected by
#   those collisions.
extends StaticBody2D

#-----------------------------------------------------------------
# Called by whoever instantiates this bumper to supply the
#   bumper's (x, y) position on the screen and its rotation (in
#   degrees).
func init( x : float, y : float, angle : float ) -> void :
  position = Vector2( x, y )
  rotation_degrees = angle

#-----------------------------------------------------------------
func deleteWhenSelected() -> void :
  # We're OK with being deleted by the user in edit mode.
  queue_free()

func getState() -> Array :
  # The information that's kept about us in a level description.
  return [ position[0], position[1], rotation_degrees ]

func moveWhenSelected( delta : Vector2 ) -> void :
  # We're OK with being moved by the user in edit mode.
  position += delta

func rotateWhenSelected( delta : float ) -> void :
  # We're OK with being rotated by the user in edit mode.
  rotation_degrees += delta

#-----------------------------------------------------------------
