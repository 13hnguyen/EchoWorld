extends KinematicBody2D

# How fast the astroid should travel
var TravelVector = Vector2( -1500, 1200 )

# Called when the node enters the scene tree for the first time.
func _ready():
  
  # Variate the asteroid trajectories
  TravelVector.x += rand_range(-300,300)
  TravelVector.y += rand_range(-200,200)
  
  $Anchor.set_rotation_degrees( rand_range(-30, 30) )
  
  var Scale = rand_range(0.8, 1.2)
  
  $Anchor.set_scale( Vector2(Scale, Scale) )
  $Shadow.set_scale( Vector2(Scale, Scale) )


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  
  # Move asteroid by delta
  position = position + TravelVector * delta
  
  # Since the shadow moves by relative location, only need to shorten the y
  $Shadow.position.y -= TravelVector.y * delta
  
  
func _on_PlayerDetector_body_entered( body : Node ) -> void :
  print( "Asteroid hit Player." )
  queue_free()

  
func _on_ShadowDetector_body_entered( body : Node ) -> void :
  
  # Only shadows should interact with 
  if is_a_parent_of(body) :
    print( "Asteroid hit ground." )
    queue_free()
