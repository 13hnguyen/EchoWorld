extends Node

# Items in this file are visible from anywhere using the "Global."
#   prefix.  Useful for keeping track of global game state info.

# Whether the user has just hit ui_cancel to exit the game.
var gameIsExiting        : = false

# Whether we're in the "paused game" state or not.
var gameIsPaused         : = false

# Which level we are currently playing.
var currentLevel         : = 0

# Whether the current level has ended yet or not.
var levelHasAlreadyEnded : = false

# How many targets are remaining in the current level.
var howManyTargets       : = 0

#-- Running totals across all levels -----------------------------
# How many levels have been played.
var totalLevelsPlayed    : = 0

# How much time has been spent across all levels.
var totalTimeTaken       : = 0.0

# How many points have been earned across all levels.
var totalPointsEarned    : = 0

#-----------------------------------------------------------------
# Converts an integer into a comma-separated string of digits.
func commaSeparatedIntStr( n : int ) -> String :
  var result : = ""
  var i : = int( abs( n ) )

  while i > 999 :
    result = ",%03d%s" % [ i % 1000, result ]
    i /= 1000

  return "%s%s%s" % [ "-" if n < 0 else "", i, result ]

#-----------------------------------------------------------------
# Convert a float number of seconds to a human=readable string of
#   the form SS, MM:SS, or HH:MM:SS.  (The number of seconds is
#   NOT rounded.)
func secondsToHMSStr( secs : float ) -> String :
  var hours : = int( secs / 3600 )
  var minutes : = int( ( secs - 3600*hours ) / 60 )
  var seconds : = int( secs - 3600*hours - 60*minutes )

  if hours > 0 :
    return "%d:%02d:%02d" % [ hours, minutes, seconds ]

  elif minutes > 0 :
    return "%d:%02d" % [ minutes, seconds ]

  return str( seconds )

#-----------------------------------------------------------------
