extends Node

func _ready() -> void :
  # We don't want the same random numbers each time.
  randomize()
  var score = get_node("On Screen Labels/PlayerScoreNum")
  var hp = get_node("On Screen Labels/PlayerHP")
  
  # loadGame will be equal to true if the level was started from loaded game data
  if GameData.loadGame == true :
    score.set_text(str(GameData.savePlayerObj.score))
    hp.set_text(str(GameData.savePlayerObj.health))
  else :
    score.set_text(str(0))
    hp.set_text(str(3))

  # Start the asteroid generation
  var AsteroidGen = preload("res://Asteroid/AsteroidGenerator.tscn")
  var asteroidGen = AsteroidGen.instance()
  asteroidGen.position = Vector2(1700, -100)
  
  # Add asteroid generator to canvas layer since it follows the player
  var canvasIndex = 0
  for n in range(1, get_child_count()) :
    var node = get_child(n)
    if node is CanvasLayer :
      canvasIndex = n
    
  get_child(canvasIndex).add_child(asteroidGen)

  # Start the rock generation
  var RockGen = preload("res://Rock/RockGenerator.tscn")
  var rockGen = RockGen.instance()
  rockGen.position = Vector2(2000, 870)
  
  # Add rock generator to canvas layer since it follows the player
    
  get_child(canvasIndex).add_child(rockGen)
  
  # Start the background music playing.
  $BackgndMusic.play()
