extends CanvasLayer

#-----------------------------------------------------------------
# The ball is a separate "screen" that we preload so we can make
#   an instance of it when a level starts.
var BALL = preload( "res://Scenes/Ball/Ball.tscn" )
var ballPath : NodePath

# We will be making up these items on the fly as well, so we
#   preload them for efficiency.
var BUMPER = preload( "res://Scenes/Bumper/Bumper.tscn" )
var TARGET = preload( "res://Scenes/Target/Target.tscn" )

# How long to wait (in seconds) after the level starts before
#   letting the ball start its movement.
const LEVEL_START_DELAY : = 1.0

#-----------------------------------------------------------------
# Paths to those items that currently exist on the playing field.
#   Used when in edit mode.  The index of the currently selected
#   item is also remembered.  (It defaults to the Player item.)
var editItems      : = []
var currentItemNum : = 0

#-----------------------------------------------------------------
# Called when the Playing Field enters the tree ...
func _ready() -> void :
  # We want to catch PlayingField_start_game signals.
# warning-ignore:return_value_discarded
  Signals.connect( "Start_level", self, "startLevel" )

  # We want to know when the user has requested entry into edit
  #   mode.
# warning-ignore:return_value_discarded
  Signals.connect( "Enter_edit_mode", self, "enterEditMode" )

  # We want to know when the user has requested exit from edit
  #   mode.
# warning-ignore:return_value_discarded
  Signals.connect( "Exit_edit_mode", self, "exitEditMode" )

  # When the Playing Field is initially loaded, everything on it
  #   is NOT visible.  (They become visible only when the level
  #   starts.)
  $Player.visible = false
  $Bumpers.visible = false
  $Targets.visible = false

#-----------------------------------------------------------------
# Called when there is an input event available ...
func _input( event: InputEvent ) -> void :
  # We are interested in input event ONLY when the game is paused,
  #   that is, in edit mode.  If we're not in edit mode, just
  #   return.
  if not Globals.gameIsPaused : return

  # Get the state of the modifier keys that can affect how we
  #   interpret the input action.
  var shift : = Input.is_key_pressed( KEY_SHIFT )
  var ctrl  : = Input.is_key_pressed( KEY_CONTROL )

  # Cycle which item is currently selected.  We move the indicator
  #   from item to item.  If SHIFT is being held down, we cycle
  #   in the reverse order.
  if event.is_action_pressed( "cycle_selected" ) :
    moveIndicatorTo( currentItemNum + ( -1 if shift else 1 ) )

  # If up, down, left, or right is the action, we move the
  #   selected item some number of pixels in that direction.  How
  #   many pixels is determined by the state of the modifier keys.
  elif event.is_action_pressed( "move_down" ) :
    moveSelected( Vector2( 0, delta( shift, ctrl ) ) )
  elif event.is_action_pressed( "move_up" ) :
    moveSelected( Vector2( 0, -delta( shift, ctrl ) ) )
  elif event.is_action_pressed( "move_left" ) :
    moveSelected( Vector2( -delta( shift, ctrl ), 0 ) )
  elif event.is_action_pressed( "move_right" ) :
    moveSelected( Vector2( delta( shift, ctrl ), 0 ) )

  # We can CW or CCW rotate the selected item.  How much it
  #   rotates is determined by the state of the modifier keys.
  elif event.is_action_pressed( "rotate_selected" ) :
    rotateSelected( delta( shift, ctrl ) )
  elif event.is_action_pressed( "reverse_rotate_selected" ) :
    rotateSelected( -delta( shift, ctrl ) )

  # We can delete the selected item.
  elif event.is_action_pressed( "delete_selected" ) :
    deleteSelected()

  # We can "increment" / "decrement" the selected item.
  elif event.is_action_pressed( "incr_selected" ) :
    incrSelected( +1 )
  elif event.is_action_pressed( "decr_selected" ) :
    incrSelected( -1 )

  # We can add a bumper or a target.
  elif event.is_action_pressed( "add_bumper" ) :
    addBumper()
  elif event.is_action_pressed( "add_target" ) :
    addTarget()

# Depending on the state of the modifier keys, we move / rotate
#   more or less units.
func delta( shift : bool, ctrl : bool ) -> int :
  if shift and ctrl : return 15
  elif ctrl         : return 10
  elif shift        : return  5
  else              : return  1

#-----------------------------------------------------------------
# Called when we enter edit mode ...
func enterEditMode() -> void :
  # Collect a list of all items in the current level that can be
  #   edited.  We do this once when we enter edit mode so we don't
  #   have to keep searching the tree for them.
  collectEditItems()

  # By default, the first collected item is selected on entry.
  #   (This is always the Player character.)
  moveIndicatorTo( 0 )

#-----------------------------------------------------------------
# Called when we exit edit mode ...
func exitEditMode() -> void :
  # Leaving edit mode, so the indicator of the selected item
  #   should no longer be visible.
  $Indicator.visible = false

  #---------------------------------------
  # We now build a dictionary representing the state of the level
  #   AFTER the user has been editing it.  This state is the same
  #   information that would be in the GameData levels.json file.

  # The Player's start position.
  var lvl = { "PlayerStart" : [ $Player.position[0], $Player.position[1] ] }

  # The ball's start position and velocity.
  var ball = get_node_or_null( ballPath )

  if ball != null :
    lvl[ "BallStart" ] = [ ball.position[0], ball.position[1] ]
    lvl[ "BallVelocity" ] = [ ball.getVelocity()[0], ball.getVelocity()[1] ]

  else :
    lvl[ "BallStart" ] = [ 0, 0 ]
    lvl[ "BallVelocity" ] = [ 0, 0 ]

  # The bumpers -- each has a location and a rotation.
  var bmprs = []
  for n in $Bumpers.get_children() :
    bmprs.append( n.getState() )
  lvl[ "Bumpers" ] = bmprs

  # The targets -- each has a location and a value.
  var tgts  = []
  for n in $Targets.get_children() :
    tgts.append( n.getState() )
  lvl[ "Targets" ] = tgts

  # Now that all level information has been collected, print a
  #   JSON version of it to the debug console.  The user can
  #   copy it from there and put it into GameData's levels.json
  #   file if they so choose.
  print( GameData.strLevel( lvl ) )

#-----------------------------------------------------------------
func collectEditItems() -> void :
  # Looks through the game tree and collects the path of each
  #   editable item.  We remember the path instead of, e.g, a
  #   reference to the item because it is SAFE to ask Godot to
  #   give us a reference for a given path.  Godot will respond
  #   with a reference or NULL, which we can check.  If we
  #   remembered an actual reference and that item was deleted,
  #   we would crash the next time we used the reference.

  # We make the first item in the editable list the Player since
  #   we know it will always exist.  It's also the default
  #   selected item.
  editItems = [ $Player.get_path() ]
  currentItemNum = 0

  # Now add all of the bumpers.  Might be none, if there happened
  #   to be no bumpers on this level.
  for n in $Bumpers.get_children() :
    editItems.append( n.get_path() )

  # Add all of the targets.  Might be none, if there happened to
  #   be no targets on this level.  (Hey, maybe the ball already
  #   hit them all!)
  for n in $Targets.get_children() :
    editItems.append( n.get_path() )

  # Add the ball, if it exists.
  if not ballPath.is_empty() :
    editItems.append( ballPath )

#-----------------------------------------------------------------
func moveIndicatorTo( item : int ) :
  # Move the indicator to the item given by the index item.

  # Unclear how this could happen, but we should check so we don't
  #   ever go into an infinite loop looking for something that
  #   doesn't exist.
  if editItems.size() == 0 :
    print( "moveIndicatorTo(%d) : editItems list was empty?" % [
      item ] )
    return

  # If the item index is off the beginning of the list, wrap it
  #   around to the last item in the list.
  if item < 0 :
    item = editItems.size() - 1

  # We loop until we find the object that is closest to the
  #   requested index AND exists to be the currently selected
  #   item.  We know this loop must exit because even if
  #   everything else is deleted, we can always default to the
  #   Player (which should ALWAYS be in the edit list).

  while true :
    # If the item index is off the end of the list, wrap it
    #   around to the first item in the list.
    if item >= editItems.size() :
      item = 0

    # item index is now within legal limts, so the currently
    #   selected item can be set to it.
    currentItemNum = item

    # Try to obtain a reference to the currently selected item
    #   using its path.
    var obj = get_node_or_null( editItems[ currentItemNum ] )

    if obj != null :
      # The object exists.  Hurray!
      # Make the indicator visible and move it to this object.
      $Indicator.position = obj.position
      $Indicator.visible  = true

      # We're done -- exit the loop.
      break

    # If we get here, the object did not exist.  Its path
    #   shouldn't have still been in the edit list.  Recollect
    #   the list of editable items and we'll try again.
    collectEditItems()

#-----------------------------------------------------------------
func moveIndicatorToPath( path : NodePath ) :
  # Move the indicator to the object with the given path.  We
  #   need to find where that path is in the edit item list.
  for index in editItems.size() :
    if path == editItems[ index ] :
      moveIndicatorTo( index )
      return

  # Hmm, path was NOT in the edit items list.  Default to the
  #   Player instead.
  print( "moveIndicatorToPath(%s) : requested path was not in edit items list?" % [
    str( path ) ] )
  moveIndicatorTo( 0 )

#-----------------------------------------------------------------
func addBumper() -> void :
  # Add a bumper to the level with location at the current mouse
  #   pointer position and rotation zero.
  var bmp = BUMPER.instance()
  var loc = get_viewport().get_mouse_position()

  bmp.init( loc[0], loc[1], 0.0 )
  $Bumpers.add_child( bmp )

  # Now that the bumper is in the level, recollect the list of
  #   editable items.  We do this so the new bumper will be in the
  #   list grouped with its fellow bumpers (instead of just at the
  #   end).
  collectEditItems()

  # Move the indicator to this newly created bumper.  We don't
  #   know its index, so we find it using its path.
  moveIndicatorToPath( bmp.get_path() )

#-----------------------------------------------------------------
func addTarget() -> void :
  # Add a target to the level with location at the current mouse
  #   pointer position and value 1.
  var tgt = TARGET.instance()
  var loc = get_viewport().get_mouse_position()

  tgt.init( 1, loc[0], loc[1] )
  $Targets.add_child( tgt )

  # Now that the target is in the level, recollect the list of
  #   editable items.  We do this so the new target will be in the
  #   list grouped with its fellow targets (instead of just at the
  #   end).
  collectEditItems()

  # Move the indicator to this newly created target.  We don't
  #   know its index, so we find it using its path.
  moveIndicatorToPath( tgt.get_path() )

#-----------------------------------------------------------------
func deleteSelected() -> void :
  # Delete the currently selected item.
  var obj = get_node_or_null( editItems[ currentItemNum ] )

  # We can delete this object only if (1) it exists (duh!) and
  #   (2) it allows itself to be deleted.  (2) is indicated by
  #   the object having a "deleteWhenSelected" method.
  if obj != null and obj.has_method( "deleteWhenSelected" ) :
    obj.deleteWhenSelected()

    # Now that the item is deleted, we have to recollect the list
    #   of editable items.
    collectEditItems()

    # The default selected item is the Player.
    moveIndicatorTo( 0 )

#-----------------------------------------------------------------
func incrSelected( incr : int ) -> void :
  # Increment (which may be + or -) the currently selected item.
  var obj = get_node_or_null( editItems[ currentItemNum ] )

  # We can increment this object only if (1) it exists (duh!) and
  #   (2) it allows itself to be incremented.  (2) is indicated by
  #   the object having a "incrWhenSelected" method.
  if obj != null and obj.has_method( "incrWhenSelected" ) :
    obj.incrWhenSelected( incr )

#-----------------------------------------------------------------
func moveSelected( howFar : Vector2 ) -> void :
  # Move the currently selected item the indicated distance.
  var obj = get_node_or_null( editItems[ currentItemNum ] )

  # We can move this object only if (1) it exists (duh!) and
  #   (2) it allows itself to be moved.  (2) is indicated by
  #   the object having a "moveWhenSelected" method.
  if obj != null and obj.has_method( "moveWhenSelected" ) :
    obj.moveWhenSelected( howFar )

    # Now that the object has moved, we have to move the indicator
    #   so it continues to indicate this item.
    moveIndicatorTo( currentItemNum )

#-----------------------------------------------------------------
func rotateSelected( howFar : float ) -> void :
  # Rotate the currently selected item the indicated angle.
  var obj = get_node_or_null( editItems[ currentItemNum ] )

  # We can rotate this object only if (1) it exists (duh!) and
  #   (2) it allows itself to be rotated.  (2) is indicated by
  #   the object having a "rotateWhenSelected" method.
  if obj != null and obj.has_method( "rotateWhenSelected" ) :
    obj.rotateWhenSelected( howFar )

#-----------------------------------------------------------------
# Called when we receive the PlayingField_start_level signal.
#   Which level to start is indicated by the parameter.
func startLevel( level : int ) -> void :
  # If we've gone off the end of the levels list, wrap around to
  #   the beginning.
  if level >= GameData.levels.size() :
    level = 0

  # The level we're on.
  Globals.currentLevel = level

  # The level has not ended yet.
  Globals.levelHasAlreadyEnded = false

  #----------
  # Position the player at its starting point.
  $Player.position = GameData.levels[level]['PlayerStart']
  $Player.visible = true

  #----------
  # Load the bumpers ...
  # We first remove any pre-existing bumpers.
  for n in $Bumpers.get_children() :
    $Bumpers.remove_child( n )
    n.queue_free()

  # Now add the bumpers corresponding to this level.
  for bSpecs in GameData.levels[level]['Bumpers'] :
    var bmp = BUMPER.instance()
    bmp.init( bSpecs[0], bSpecs[1], bSpecs[2] )
    $Bumpers.add_child( bmp )

  # Bumpers are now visible.
  $Bumpers.visible = true

  #----------
  # Load the targets
  # We first remove any pre-existing targets.
  for n in $Targets.get_children() :
    $Targets.remove_child( n )
    n.queue_free()

  # Reset the running count of targets that exist on this
  #   level to zero.  As we add targets, each one increments this
  #   count.  (As a target is destroyed, it decrements this count.
  #   When it reaches zero, we know the level has ended.)
  Globals.howManyTargets = 0

  # Now add the targets corresponding to this level.
  for tSpecs in GameData.levels[level]['Targets'] :
    var tgt = TARGET.instance()
    tgt.init( tSpecs[0], tSpecs[1], tSpecs[2] )
    $Targets.add_child( tgt )

  # Targets are now visible.
  $Targets.visible = true

  #----------
  # Get rid of the previous ball, if it still exists.
  if not ballPath.is_empty() :
    var oldBall = get_node_or_null( ballPath )

    if oldBall != null :
      oldBall.queue_free()

  # Make a new instance of the ball and add it as a child node of
  #   the playing field.
  var ball = BALL.instance()
  add_child( ball )

  # Remember the path to this ball instance so we can easily find
  #   it when we want to delete it.
  ballPath = ball.get_path()

  #----------
  # Wait a sliver of time so the player can "get ready" for the
  #   ball to appear on the screen.
  # This works by starting a "throw-away" timer with the given
  #   delay.  When that delay expires ("timeout"), control
  #   continues past this call.
  yield( get_tree().create_timer( LEVEL_START_DELAY ), "timeout" )

  # Start the ball instance at the desired spot.
  ball.start( GameData.levels[level]['BallStart'], GameData.levels[level]['BallVelocity'] )

#-----------------------------------------------------------------
