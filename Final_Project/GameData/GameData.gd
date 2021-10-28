# This script takes care of loading game data from a json file using autoload setting

extends Node

const filename_path = "res://GameData/gamedata.json"

var data = {};

func _ready() -> void :
  var loadFile = File.new()
  var err = loadFile.open(filename_path, File.READ)
  
  if err :
    print( "Unable to open game data file %s because %s." % [
        filename_path, err ] )
    get_tree().quit( 1 )
    return

  var result = JSON.parse( loadFile.get_as_text() )
  if result.error != OK :
    print( "Unable to parse contents of game data file %s." % [
      filename_path ] )
    print( "JSON error was %s, %s on line %d." % [
      result.error, result.error_string, result.error_line ] )
    get_tree().quit( 1 )
    return

  data = result.result
  print(data)
