extends Node

var AsteroidGenInstance = preload("res://Asteroid/AsteroidGenerator.tscn")
var AsteroidGen

var AsteroidGenPlayerDistance = 0.0

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
  AsteroidGen = AsteroidGenInstance.instance()
  add_child(AsteroidGen)
  AsteroidGen.position = Vector2(1300, -100)
  
  AsteroidGenPlayerDistance = AsteroidGen.position.x - $Player.position.x
  
  # Add asteroid generator to canvas layer since it follows the player
  var canvasIndex = 0
  for n in range(1, get_child_count()) :
    var node = get_child(n)
    if node is CanvasLayer :
      canvasIndex = n

  #Start the enemy generation
  var EnemyGen = preload("res://Enemy/EnemyGenerator.tscn")
  var enemyGen = EnemyGen.instance()
  enemyGen.position = Vector2(2000, 800)
  
  # Add enemybgenerator to canvas layer since it follows the player  
  get_child(canvasIndex).add_child(enemyGen)
  
  #Start the rock generation
  #var RockGen = preload("res://Rock/RockGenerator.tscn")
  #var rockGen = RockGen.instance()
  #rockGen.position = Vector2(2000, 870)
  
  # Add rock generator to canvas layer since it follows the player
    
  #get_child(canvasIndex).add_child(rockGen)
  
  
  # Start the background music playing.
  $BackgndMusic.play()
  
  
func _process(_delta):
  AsteroidGen.position.x = $Player.position.x + AsteroidGenPlayerDistance
