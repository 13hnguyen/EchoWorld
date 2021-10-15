extends Node

const GAME_DATA = "res://GameData/levels.json"

#-----------------------------------------------------------------
#-- Description of the levels file                              --
#-----------------------------------------------------------------
# The levels.json file is a JSON-format file expressing the
#   design of the levels for this game.  The levels are expressed
#   as a list:  [ <level0>, <level1>, ... ]

#   Each <leveln> is a dictionary: { "key0" : <value0>, ... }
#   with the following key / value pairs REQUIRED.

# > "BallStart" : [ x, y ]
#     Starting location of the ball.

# > "BallVelocity" : [ vx, vy ]
#     Starting velocity of the ball.

# > "Bumpers" : [ [ x, y, r ], ... ]
#     Position / rotation of each bumper.  Rotation is expressed
#     in degrees.

# > "PlayerStart" : [ x, y ]
#     Starting location of the player.

# > "Targets" : [ [ v, x, y ], ... ]
#     Value / position of each target.
#-----------------------------------------------------------------

var levels = []

func _ready() -> void :
  var gdFile : = File.new()

  var err = gdFile.open( GAME_DATA, File.READ )

  if err :
    print( "Unable to open game data file %s because %s." % [
      GAME_DATA, err ] )
    get_tree().quit( 1 )
    return

  var result = JSON.parse( gdFile.get_as_text() )
  if result.error != OK :
    print( "Unable to parse contents of game data file %s." % [
      GAME_DATA ] )
    print( "JSON error was %s, %s on line %d." % [
      result.error, result.error_string, result.error_line ] )
    get_tree().quit( 1 )
    return

  levels = result.result

  for lvl in levels :
    lvl["BallStart"]    = Vector2( lvl["BallStart"][0], lvl["BallStart"][1] )
    lvl["BallVelocity"] = Vector2( lvl["BallVelocity"][0], lvl["BallVelocity"][1] )
    lvl["PlayerStart"]  = Vector2( lvl["PlayerStart"][0], lvl["PlayerStart"][1] )

  print( "%d level%s in game data." % [
    levels.size(), "" if levels.size() == 1 else "s" ] )

#-----------------------------------------------------------------
func strLevel( level : Dictionary ) -> String :
  var indent  : = "  "
  var indent2 : = "    "
  var indent3 : = "      "

  var result  : = ""

  #---------------------------------------
  result += "%s{\n" % [ indent ]

  #---------------------------------------
  result += "%s\"BallStart\"    : [ %7.1f, %7.1f ],\n" % [
    indent2, level["BallStart"][0], level["BallStart"][1] ]

  #---------------------------------------
  result += "%s\"BallVelocity\" : [ %7.1f, %7.1f ],\n" % [
    indent2, level["BallVelocity"][0], level["BallVelocity"][1] ]

  #---------------------------------------
  result += "%s\"Bumpers\"      : [\n" % [ indent2 ]

  var bmpers : = []

  for bmp in level["Bumpers"] :
    bmpers.append( "%s[ %7.1f, %7.1f, %7.1f ]" % [
      indent3, bmp[0], bmp[1], bmp[2] ] )

  result += "%s\n%s],\n" % [
    PoolStringArray( bmpers ).join( ",\n"), indent2 ]

  #---------------------------------------
  result += "%s\"PlayerStart\"  : [ %7.1f, %7.1f ],\n" % [
    indent2, level["PlayerStart"][0], level["PlayerStart"][1] ]

  #---------------------------------------
  result += "%s\"Targets\"      : [\n" % [ indent2 ]

  var tgts : = []

  for tgt in level["Targets"] :
    tgts.append( "%s[ %4d, %7.1f, %7.1f ]" % [
      indent3, tgt[0], tgt[1], tgt[2] ] )

  result += "%s\n%s],\n" % [
    PoolStringArray( tgts ).join( ",\n"), indent2 ]

  #---------------------------------------
  result += "%s}\n" % [ indent ]

  #---------------------------------------
  return result

#-----------------------------------------------------------------
