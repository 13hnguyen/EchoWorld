extends Node2D

# These determine the asteroid spawn location
var SpawnMin = Vector2(-200, -100)
var SpawnMax = Vector2(200, 100)

# This is the range of the ground that the asteroid will eventually hit
#    and where the shadow will appear
var GroundMin = 840 
var GroundMax = 1000

# Spawn rates
var SpawnRate = 0.8 # Asteroids per sec
var SpawnTime = 1.0 / SpawnRate
var SpawnVariance = 0.5

# Keeps track of time since last asteroid was spawned
var TimeSince = 0.0

# Referrence to asteroid node script
var ObstacleNode = preload("res://FlyingObstacle/L0_asteroid/Asteroid.tscn")


# Debug options
var DrawDebugRect = false

func set_obstacle_node(path : String):
  ObstacleNode = load(path);


# Called when the node enters the scene tree for the first time.
func _ready():
  TimeSince = SpawnTime + rand_range(-SpawnVariance, SpawnVariance)
  
  # Hide sprite, only used as a visual referrence in the editor
  $Sprite.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  TimeSince -= delta
  
  # Spawn asteroid
  if TimeSince <= 0.0 :
    #print("new asteroid")
    TimeSince = SpawnTime + rand_range(-SpawnVariance, SpawnVariance)
    
    if(ObstacleNode == null) :
      print("ERROR: AsteroidNode was set to an invalid path.");
    
    # Create the asteroid node and set it's position randomly within Min and Max
    var Asteroid = ObstacleNode.instance()
    get_parent().add_child(Asteroid)
    
    # Randomly hit somewhere on the ground
    var GroundHitY = rand_range(GroundMin, GroundMax)
    
    # Make the hit relative to the generator
    GroundHitY -= position.y
    
    # Randomly pick a location in the relative rect
    var x = rand_range(SpawnMin.x, SpawnMax.x)
    var y = rand_range(SpawnMin.y, SpawnMax.y)
    
    Asteroid.position = Vector2(x, y) + global_position
    
    # Now we set the shadow within the range of Min and Max
    var Shadow = Asteroid.get_child(0)
    
    # Set position of the shadow relative to the asteroid's y axis
    Shadow.position.y = GroundHitY - y
    
    # Only update if we are debugging
    if DrawDebugRect :
      update()
    
# This function is only used for drawing the rectangle in which the Asteroids are spawned in
# Handy for debugging
func _draw() :
  
  if DrawDebugRect :
    draw_rect(Rect2(SpawnMin, SpawnMax - SpawnMin), Color(255, 0, 0), false, 5.0)
    
