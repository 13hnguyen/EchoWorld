extends Node2D

# These determine the rock spawn location
var SpawnMin = Vector2(-200, -100)
var SpawnMax = Vector2(200, 100)

# This is the range of the ground that the rock will eventually hit
#    and where the shadow will appear
var GroundMin = 850 
var GroundMax = 1000

# Spawn rates
var SpawnRate = 1.0 # Rocks per sec
var SpawnTime = 1.0 / SpawnRate
var SpawnVariance = 0.1

# Keeps track of time since last rock was spawned
var TimeSince = 0.0

# Referrence to rock node script
var RockNode = preload("res://Rock/Rock.tscn")


# Debug options
var DrawDebugRect = false


# Called when the node enters the scene tree for the first time.
func _ready():
  TimeSince = SpawnTime + rand_range(0, SpawnVariance)
  
  # Hide sprite, only used as a visual referrence in the editor
  $Sprite.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  TimeSince -= delta
  
  # Spawn rock
  if TimeSince <= 0.0 :
    TimeSince = SpawnTime + rand_range(0, SpawnVariance)
    
    # Create the rock ndoe and set it's position randomly within Min and Max
    var Rock = RockNode.instance()
    add_child(Rock)
    
    # Randomly hit somewhere on the ground
    var GroundHitY = rand_range(GroundMin, GroundMax)
    
    # Make the hit relative to the generator
    GroundHitY -= position.y
    
    # Randomly pick a location in the relative rect
    var x = rand_range(SpawnMin.x, SpawnMax.x)
    var y = rand_range(SpawnMin.y, SpawnMax.y)
    
    Rock.position = Vector2(x, y)
    
    
    $Sprite.position = Vector2(0,0)
    
    # Only update if we are debugging
    if DrawDebugRect :
      update()
    
# This function is only used for drawing the rectangle in which the Rocks are spawned in
# Handy for debugging
func _draw() :
  
  if DrawDebugRect :
    draw_rect(Rect2(SpawnMin, SpawnMax - SpawnMin), Color(255, 0, 0), false, 5.0)
    
