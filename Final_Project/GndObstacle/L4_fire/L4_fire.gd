extends StaticBody2D

# Spawn rates
var SpawnRate = 0.25 # enemy per sec
var SpawnTime = 0.8 / SpawnRate
var SpawnVariance = 0.5

# Keeps track of time since last enemy was spawned
var TimeSince = 0.0

var EnemyNode = preload("res://Enemy/FireLionEnemy/FireLionEnemy.tscn")

# Debug options
var DrawDebugRect = true

#for the fire to burn
func _ready():
    get_node("AnimationFire").play("fire")
    
    TimeSince = SpawnTime + rand_range(-SpawnVariance, SpawnVariance)

func _process(delta):
  TimeSince -= delta
  
  # Spawn enemy
  if TimeSince <= 0.0 :
    #print("new enemy")
    TimeSince = SpawnTime + rand_range(-SpawnVariance, SpawnVariance)
    
    # Create the enemy node and set it's position randomly within Min and Max
    var Enemy = EnemyNode.instance()
    get_parent().add_child(Enemy)
    
    Enemy.position = $LionSpawnLocation.position + global_position
