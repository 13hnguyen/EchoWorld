# This script takes care of loading and saving data from/to json file

extends Node

# filename path for the json file
const filename_path = "res://GameData/gamedata.json"

var data = {}; # object that is saved/loaded to/from json file
var newPlayerObj = {}; # object for new player creation
var savePlayerObj = {}; # object for saving data for existing player
var loadGame = false; # default is false because the default is expected to be a new game

func _ready() -> void :
  savePlayerObj.score = -1; # used to check if the player earned any points from the level in savePlayerData function
  
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

# function to save the new player to the json file
func saveNewPlayer(player) -> void :
  print("new player name received: " + player)
  loadGame = false;
  savePlayerObj.name = player; # update the current player name to be seen outside the scope of this function

  # create a new player object in json format
  newPlayerObj.name = player;
  newPlayerObj.level = 0;
  newPlayerObj.score = 0;
  newPlayerObj.health = 3;
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

# function to save new player data for an existing player in the json file
func savePlayerData() -> void :
  print("saving player data...")
  #print(savePlayerObj.name)
  #print(savePlayerObj.level)
  #print(savePlayerObj.health)
  
  # if the player earned no points during level, then score will still be default value -1, otherwise score comes from bullet.gd script for hitting targets
  if (savePlayerObj.score == -1) :
    savePlayerObj.score = 0;
  #print(savePlayerObj.score)
  
  # overwrite the old player data with the new data
  for n in data[0].players :
    if n.name == savePlayerObj.name :
      #print(n)
      print("found existing player in file...overwritting data")
      n.name = savePlayerObj.name
      n.level = savePlayerObj.level
      n.health = savePlayerObj.health
      n.score = savePlayerObj.score
    else :
      print("player does not match, checking next player in file")
  #print(data)
  
  var file
  file = File.new()
  file.open(filename_path, File.WRITE)
  file.store_line(to_json(data))
  file.close()
  print("player data saved")

# function to load player data for a level
func loadPlayer(index) -> void :
  var player = data[0].players[index]
  loadGame = true # swap to true to trigger the score and health to use these values from the bullet.gd and player.gd scripts
  savePlayerObj.name = player.name;
  savePlayerObj.score = player.score;
  savePlayerObj.health = player.health;
  print(savePlayerObj)
  print("loading player data for " + player.name)
  if (player.level == 0) :
    print(player.name + " is on level 0. level being loaded")
    var _scene = get_tree().change_scene("res://Level/Level.tscn")
  elif (player.level  == 1) :
    print(player.name + " is on level 1. level 1 is not created yet")
  elif (player.level == 2) :
    print(player.name + " is on level 2. level 2 is not created yet")
  elif (player.level == 3) :
    print(player.name + " is on level 3. level 3 is not created yet")
  elif (player.level == 4) :
    print(player.name + " is on level 4. level 4 is not created yet")
  elif (player.level == 5) :
    print(player.name + " is on level 5. level 5 is not created yet")
  print("player game loaded successful")

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
