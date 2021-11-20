# This script takes care of loading and saving data from/to json file

extends Node

# filename path for the json file
const filename_path = "res://GameData/gamedata.json"

# array to hold planet names. these are used in the planet menu and are in ascending order of planets
const planetNames = ["Admetus","Pleiades","Boreas","Cerberus","Eros","Icarus"]

var data = {}; # object that is saved/loaded to/from json file
var newPlayerObj = {}; # object for new player creation
var savePlayerObj = {}; # object for saving data for existing player
var tryAgain = false; # default is false.  turns true when when player restarts from death to reset HP and then becomes false again

func _ready() -> void :
  
  # load the data from the json file
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
  print("data from json:")
  print(data)




###############################################################################################################
# function to save the new player to the json file

func saveNewPlayer(player) -> void :
  print("new player name received: " + player)
  savePlayerObj.name = player; # update the current player name to be seen outside the scope of this function
  savePlayerObj.level = 0; # default new players to level 0 (this is important for re-trying after death screen since the level only updates when the player hits a portal)

  # create a new player object in json format
  newPlayerObj.name = player;
  newPlayerObj.level = 0;
  #print(newPlayerObj)

  data[0].players.push_back(newPlayerObj)
  newPlayerObj = {}; # resetting object for next new player
  #print(data)
  #print(data[0].players.size())

  var file
  file = File.new()
  file.open(filename_path, File.WRITE)
  file.store_line(to_json(data))
  file.close()
  
###############################################################################################################




###############################################################################################################
# function to save new player data for an existing player in the json file

func savePlayerData() -> void :
  print("saving player data...")
  #print(savePlayerObj.name)
  #print(savePlayerObj.level)
  
  # overwrite the old player data with the new data
  for n in data[0].players :
    if n.name == savePlayerObj.name :
      #print(n)
      print("found existing player in file...overwritting data")
      n.name = savePlayerObj.name
      n.level = savePlayerObj.level
    else :
      print("player does not match, checking next player in file")
  #print(data)
  
  var file
  file = File.new()
  file.open(filename_path, File.WRITE)
  file.store_line(to_json(data))
  file.close()
  print("player data saved")
  
###############################################################################################################




###############################################################################################################
# function to load player data for a level

func loadPlayer(index) -> void :
  var player = data[0].players[index]
  savePlayerObj.name = player.name
  savePlayerObj.level = player.level
  print(savePlayerObj)
  print("loading player data for " + player.name)
  if (player.level == 0) :
    print(player.name + " is on level 0. level being loaded")
    var _scene = get_tree().change_scene("res://Level/Level0.tscn")
  elif (player.level  == 1) :
    print(player.name + " is on level 1. level 1 being loaded")
    var _scene = get_tree().change_scene("res://Level/Level1.tscn")
  elif (player.level == 2) :
    print(player.name + " is on level 2. level 2 being loaded")
    var _scene = get_tree().change_scene("res://Level/Level2.tscn")
  elif (player.level == 3) :
    print(player.name + " is on level 3. level 3 is being loaded")
    var _scene = get_tree().change_scene("res://Level/Level3.tscn")
  elif (player.level == 4) :
    print(player.name + " is on level 4. level 4 is being loaded")
    var _scene = get_tree().change_scene("res://Level/Level4.tscn")
  elif (player.level == 5) :
    print(player.name + " is on level 5. level 5 is being loaded")
    var _scene = get_tree().change_scene("res://Level/Level5.tscn")
  elif (player.level == 6) :
    print(player.name + " is on level 6, so you have won the game!")
    var _scene = get_tree().change_scene("res://Menus/GameWon.tscn")

###############################################################################################################




###############################################################################################################
# function to delete player data from json file

func deletePlayer(player) -> void :
  print("received player name to delete: " + player)

  for n in data[0].players :
    if n.name == player :
      data[0].players.erase(n)
  #print(data)
  
  var file
  file = File.new()
  file.open(filename_path, File.WRITE)
  file.store_line(to_json(data))
  file.close()
  print("player deletion successful")

###############################################################################################################
