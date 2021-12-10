extends Node

var handGeneratorInstance = preload("res://FlyingObstacle/FlyingObstacleGenerator.tscn")
var handGen
var EnemyGen

var handGenPlayerDistance = 0.0
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

  # Start the Germ generation
  handGen = handGeneratorInstance.instance()
  add_child(handGen)
  handGen.position = Vector2(1300, -100)
  # set the Germ node
  handGen.call_deferred("set_obstacle_node", "res://FlyingObstacle/L5_hand/hand.tscn")
  
  handGenPlayerDistance = handGen.position.x - $Player.position.x
  
  #Start the enemy generation
  EnemyGen = preload("res://Enemy/TenteyeEnemy/TenteyeEnemyGenerator.tscn").instance()
  EnemyGen.position = Vector2(1800, 700)
  
  # Add enemybgenerator to canvas layer since it follows the player  
  add_child(EnemyGen)
  
  EnemyGenPlayerDistance = EnemyGen.position.x - $Player.position.x
  
  
  # Start the background music playing.
  $BackgndMusic.play()
  
  
func _process(_delta):
  handGen.position.x = $Player.position.x + handGenPlayerDistance
  EnemyGen.position.x =    $Player.position.x + EnemyGenPlayerDistance
