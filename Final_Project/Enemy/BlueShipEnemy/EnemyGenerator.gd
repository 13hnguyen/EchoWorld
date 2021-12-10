extends Node2D

# These determine the enemy spawn location
var SpawnMin = Vector2(0, -10)
var SpawnMax = Vector2(2000, -400)

# Spawn rates
var SpawnRate = 0.25 # enemy per sec
var SpawnTime = 0.8 / SpawnRate
var SpawnVariance = 0.5

# Keeps track of time since last enemy was spawned
var TimeSince = 0.0

var EnemyNode = preload("res://Enemy/BlueShipEnemy/Enemy.tscn")

# Debug options
var DrawDebugRect = true

# Called when the node enters the scene tree for the first time.
func _ready():
  TimeSince = SpawnTime + rand_range(-SpawnVariance, SpawnVariance)
  
  # Hide sprite, only used as a visual referrence in the editor
  $Sprite.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  TimeSince -= delta
  
  # Spawn enemy
  if TimeSince <= 0.0 :
    #print("new enemy")
    TimeSince = SpawnTime + rand_range(-SpawnVariance, SpawnVariance)
    
    # Create the enemy node and set it's position randomly within Min and Max
    var Enemy = EnemyNode.instance()
    get_parent().add_child(Enemy)
    
    # Randomly pick a location in the relative rect
    var x = rand_range(SpawnMin.x, SpawnMax.x)
    var y = rand_range(SpawnMin.y, SpawnMax.y)
    
    Enemy.position = Vector2(x, y) + global_position
    
    $Sprite.position = Vector2(0,0)
    
    # Only update if we are debugging
    if DrawDebugRect :
      update()
    
# This function is only used for drawing the rectangle in which the Rocks are spawned in
# Handy for debugging
func _draw() :
  
  if DrawDebugRect :
    draw_rect(Rect2(SpawnMin, SpawnMax - SpawnMin), Color(255, 0, 0), false, 5.0)
    
