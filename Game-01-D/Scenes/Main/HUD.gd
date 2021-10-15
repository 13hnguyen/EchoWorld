extends CanvasLayer

# How many points has the player scored.
var score : = 0

# Whether the time counter should be incremented.
var countingTime : = false

# How much playing time has passed.
var time  : = 0.0

# How long to wait after showing the end-of-level message before
#   showing the replay / next level buttons.
const BUTTON_DISPLAY_DELAY : = 3.0

#-----------------------------------------------------------------
# Called when the HUD is added to the tree.
func _ready() -> void :
  $StartBtn.visible   = true
  $MessageLbl.visible = false
  $ScoreLbl.visible   = false
  $TimeLbl.visible    = false
  $ReplayBtn.visible  = false
  $NextBtn.visible    = false

  # We want to catch these signals so we connect them to the
  #   appropriate processing routines.

# warning-ignore:return_value_discarded
  Signals.connect( "Start_level", self, "startLevel" )

# warning-ignore:return_value_discarded
  Signals.connect( "End_level", self, "showEndLevel" )

# warning-ignore:return_value_discarded
  Signals.connect( "Incr_score", self, "incrScore" )

#-----------------------------------------------------------------
# Called every frame.
func _physics_process( delta : float ) -> void :
  # When the game is paused -- in edit mode -- we don't update the
  #   HUD, so just return.
  if Globals.gameIsPaused : return

  # If we're counting time, accumulate however much has passed
  #   since the last frame and show a human-readable
  #   representation in the HUD.
  if countingTime :
    time += delta
    $TimeLbl.text = Globals.secondsToHMSStr( time )

  else :
    # Not counting time, so the time display is the empty string.
    $TimeLbl.text = ""

#-----------------------------------------------------------------
# Add the given increment (1 if omitted) to the score.
func incrScore( incr : int = 1 ) -> void :
  setScore( score + incr )

#-----------------------------------------------------------------
# Set the value of the score and update its HUD display.
func setScore( value : int ) -> void :
  score = value
  $ScoreLbl.text = Globals.commaSeparatedIntStr( score )

#-----------------------------------------------------------------
# Called when we receive the HUD_end_game signal.  See _ready()
#   above for the connection.
func showEndLevel( msg ) :
  # Since the level is over, we're no longer counting the time and
  #   don't display the on-screen score or time.
  countingTime = false
  $ScoreLbl.visible = false
  $TimeLbl.visible = false

  # Put an informative message in the MessageLbl (using the msg
  #   string we were given) ...
  Globals.totalLevelsPlayed += 1
  Globals.totalPointsEarned += score
  Globals.totalTimeTaken    += time

  $MessageLbl.text = "%s\nYou scored %d point%s in %.1f seconds.\n%d total point%s in %.1f seconds across %d level%s." % [
    msg,
    score, "" if score == 1 else "s", time,
    Globals.totalPointsEarned, "" if Globals.totalPointsEarned == 1 else "s",
    Globals.totalTimeTaken,
    Globals.totalLevelsPlayed, "" if Globals.totalLevelsPlayed == 1 else "s" ]

  # ... and make the MessageLbl visible.
  $MessageLbl.visible = true

  # We delay a sliver of time after showing the message before
  #   showing the carry-on buttons.
  yield( get_tree().create_timer( BUTTON_DISPLAY_DELAY ), "timeout" )

  # Show the carry-on buttons -- that is, how the user wants to
  #   carry on from here:  replay the level or go to the next
  #   level.
  $ReplayBtn.visible = true
  $NextBtn.visible   = true

#-----------------------------------------------------------------
# Called when we receive the HUD_start_level signal.  See _ready()
#   above for the connection.
func startLevel( _level : int ) -> void :
  # Since we're starting the level, the START button no longer
  #   needs to be visible.
  $StartBtn.visible   = false

  # We don't get to see these buttons until the level is over.
  $ReplayBtn.visible  = false
  $NextBtn.visible    = false

  # The score and the in-game time count both start at 0.  We now
  #   start accumulating in-game time as well.
  setScore( 0 )
  time = 0
  countingTime = true

  # The MessageLbl is NOT visible (we use it only when the level
  #   ends), but the on-screen score and time labels are visible.
  $MessageLbl.visible = false
  $ScoreLbl.visible   = true
  $TimeLbl.visible    = true

#-----------------------------------------------------------------
# When the START button is pressed, we let everyone know.
func _on_StartBtn_pressed() -> void :
  Signals.emit_signal( "Level_has_started", 0 )

#-----------------------------------------------------------------
# When the Replay button is pressed, we announce the starting of
#   the current level once again.
func _on_ReplayBtn_pressed() -> void :
  $ReplayBtn.visible = false
  $NextBtn.visible   = false

  Signals.emit_signal( "Level_has_started", Globals.currentLevel )

#-----------------------------------------------------------------
# When the Next button is pressed, we announce the starting of
#   the current level plus 1.
func _on_NextBtn_pressed() -> void :
  $ReplayBtn.visible = false
  $NextBtn.visible   = false

  Signals.emit_signal( "Level_has_started", Globals.currentLevel+1 )

#-----------------------------------------------------------------
