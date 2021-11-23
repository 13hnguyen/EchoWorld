extends Node

var YellowGooeyBallGeneratorInstance = preload("res://FlyingObstacle/FlyingObstacleGenerator.tscn")
var YellowGooeyBallGen
var EnemyGen

var YellowGooeyBallGenPlayerDistance = 0.0
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

  # Start the Yellow Gooey Ball generation
  YellowGooeyBallGen = YellowGooeyBallGeneratorInstance.instance()
  add_child(YellowGooeyBallGen)
  YellowGooeyBallGen.position = Vector2(1300, -100)
  # set the Yellow Gooey Ball node
  YellowGooeyBallGen.call_deferred("set_obstacle_node", "res://FlyingObstacle/L2_yellowgooeyball/YellowGooeyBall.tscn")
  
  YellowGooeyBallGenPlayerDistance = YellowGooeyBallGen.position.x - $Player.position.x
  
  #Start the enemy generation
  EnemyGen = preload("res://Enemy/BeeEnemy/BeeEnemyGenerator.tscn").instance()
  EnemyGen.position = Vector2(1800, 700)
  
  # Add enemybgenerator to canvas layer since it follows the player  
  add_child(EnemyGen)
  
  EnemyGenPlayerDistance = EnemyGen.position.x - $Player.position.x

  # Start the background music playing.
  $BackgndMusic.play()
  
  
func _process(_delta):
  YellowGooeyBallGen.position.x = $Player.position.x + YellowGooeyBallGenPlayerDistance
  EnemyGen.position.x =    $Player.position.x + EnemyGenPlayerDistance
