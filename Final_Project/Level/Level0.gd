extends Node

var AsteroidGenInstance = preload("res://FlyingObstacle/FlyingObstacleGenerator.tscn")
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
  # set the asteroid node
  #AsteroidGen.call_deferred("set_obstacle_node", "res://FlyingObstacle/L1_germ/Germ.tscn")
  
  AsteroidGenPlayerDistance = AsteroidGen.position.x - $Player.position.x
  
  #Start the enemy generation
  EnemyGen = preload("res://Enemy/BlueShipEnemy/EnemyGenerator.tscn").instance()
  EnemyGen.position = Vector2(1800, 700)
  
  # Add enemybgenerator to canvas layer since it follows the player  
  add_child(EnemyGen)
  
  EnemyGenPlayerDistance = EnemyGen.position.x - $Player.position.x
  
 
  # Start the background music playing.
  $BackgndMusic.play()
  
  
func _process(_delta):
  AsteroidGen.position.x = $Player.position.x + AsteroidGenPlayerDistance
  EnemyGen.position.x =    $Player.position.x + EnemyGenPlayerDistance
