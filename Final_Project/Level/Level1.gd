extends Node

var GermGeneratorInstance = preload("res://FlyingObstacle/FlyingObstacleGenerator.tscn")
var GermGen
var EnemyGen

var GermGenPlayerDistance = 0.0
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
  GermGen = GermGeneratorInstance.instance()
  add_child(GermGen)
  GermGen.position = Vector2(1300, -100)
  # set the Germ node
  GermGen.call_deferred("set_obstacle_node", "res://FlyingObstacle/L1_germ/Germ.tscn")
  
  GermGenPlayerDistance = GermGen.position.x - $Player.position.x
  
  #Start the enemy generation
  EnemyGen = preload("res://Enemy/BlueShipEnemy/EnemyGenerator.tscn").instance()
  EnemyGen.position = Vector2(1800, 700)
  
  # Add enemybgenerator to canvas layer since it follows the player  
  add_child(EnemyGen)
  
  EnemyGenPlayerDistance = EnemyGen.position.x - $Player.position.x
  
  
  # Start the background music playing.
  $BackgndMusic.play()
  
  
func _process(_delta):
  GermGen.position.x = $Player.position.x + GermGenPlayerDistance
  EnemyGen.position.x =    $Player.position.x + EnemyGenPlayerDistance
