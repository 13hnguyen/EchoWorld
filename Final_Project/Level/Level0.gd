extends Node

var AsteroidGenInstance = preload("res://Asteroid/AsteroidGenerator.tscn")
var AsteroidGen
var EnemyGen

var AsteroidGenPlayerDistance = 0.0
var EnemyGenPlayerDistance = 0.0

func _ready() -> void :
  # We don't want the same random numbers each time.
  randomize()
  var score = get_node("On Screen Labels/PlayerScoreNum")
  var hp = get_node("On Screen Labels/PlayerHP")
  score.set_text(str(0))
  hp.set_text(str(3))
    
  if GameData.tryAgain == true:
    hp.set_text(str(3))
    GameData.tryAgain = false

  # Start the asteroid generation
  AsteroidGen = AsteroidGenInstance.instance()
  add_child(AsteroidGen)
  AsteroidGen.position = Vector2(1300, -100)
  
  AsteroidGenPlayerDistance = AsteroidGen.position.x - $Player.position.x
  
  #Start the enemy generation
  EnemyGen = preload("res://Enemy/EnemyGenerator.tscn").instance()
  EnemyGen.position = Vector2(1800, 700)
  
  # Add enemybgenerator to canvas layer since it follows the player  
  add_child(EnemyGen)
  
  EnemyGenPlayerDistance = EnemyGen.position.x - $Player.position.x
  
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
  EnemyGen.position.x =    $Player.position.x + EnemyGenPlayerDistance
