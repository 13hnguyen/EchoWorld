extends Node

#-----------------------------------------------------------------
# A handle to the background we're going to use during a game.
#   By default, the "splash screen" image is shown but once a
#   game starts, we want this image instead as the background
#   behind the levels.
var GRAPH_BACKGROUND = preload( "res://Art/Background-GraphPaper.png" )

#-----------------------------------------------------------------
# Gets called when the main scene is added to the tree.
func _ready() -> void :
  # We want to hear about "Level_has_started" messages.
# warning-ignore:return_value_discarded
  Signals.connect( "Level_has_started", self, "levelStarted" )

  # We want to hear about "Level_has_ended" messages.
# warning-ignore:return_value_discarded
  Signals.connect( "Level_has_ended", self, "levelEnded" )

#-----------------------------------------------------------------
# Called when there's an input event ...
func _input( event : InputEvent ) -> void :
  # If the user wants out (normally indicated by hitting the ESC
  #   key), just quit the game.
  if event.is_action_pressed( "ui_cancel" ) :
	print( "%7.3f: User hit ui_cancel.  Ending game." % [
	  OS.get_ticks_msec() / 1000.0 ] )

	Globals.gameIsExiting = true
	get_tree().quit( 0 )

  # The user has requested pausing the level (so they can edit the
  #   level).  This action is actually a toggle -- hit it once to
  #   go into edit mode, hit it again to come out of edit mode.
  elif event.is_action_pressed( "pause_mode" ) :
	# Toggle the state of being paused.
	Globals.gameIsPaused = not Globals.gameIsPaused

	print( "%7.3f: Game is now %spaused." % [
	  OS.get_ticks_msec() / 1000.0,
	  "" if Globals.gameIsPaused else "not " ] )

	# Emit the correct signal about this transition:  Either
	#   into edit mode or out of edit mode.  This informs
	#   anyone who cares so they can take their own proper
	#   actions.
	if Globals.gameIsPaused :
	  Signals.emit_signal( "Enter_edit_mode" )

	else :
	  Signals.emit_signal( "Exit_edit_mode" )

#-----------------------------------------------------------------
# Called when we receive the "Level_has_started" signal.
func levelStarted( level ) -> void :
  print( "%7.3f: Level %d start requested." % [
	OS.get_ticks_msec() / 1000.0, level ] )

  # Change the background to the graph paper version since we are
  #   actually going to be playing a level now.
  $Background/TextureRect.texture = GRAPH_BACKGROUND

  # Signal the HUD and the Playing Field that the level is
  #   starting.
  Signals.emit_signal( "Start_level", level )

#-----------------------------------------------------------------
# Called when we receive the "Level_has_ended" signal.  Whoever
#   detected that the level has ended emits this signal and
#   provides a message (a String) indicating WHY the level ended.
func levelEnded( msg ) -> void :
  if Globals.gameIsExiting : return

  print( "%7.3f: Level has ended because \"%s\"." % [
	OS.get_ticks_msec() / 1000.0, msg ] )

  # Remember that the level has ended.  This lets EVERYONE know
  #   that the level is over.  (So, e.g., we don't get duplicate
  #   messages.)
  Globals.levelHasAlreadyEnded = true

  # Tell the HUD to show the "Level Ended" display with the
  #   provided message.
  Signals.emit_signal( "End_level", msg )

#-----------------------------------------------------------------
