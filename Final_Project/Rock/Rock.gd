extends KinematicBody2D

# How fast the astroid should travel
var TravelVector = Vector2( -200, 0 )

# Called when the node enters the scene tree for the first time.
func _ready():
  
  show()
  
  var Scale = rand_range(0.8, 1.2)
  
  $Anchor.set_scale( Vector2(Scale, Scale) )


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  # Move rock by delta
  position = position + TravelVector * delta
  
  
func _on_PlayerDetector_body_entered( _body : Node ) -> void :
  print( "Rock hit Player." )
  #Do not free the rock if it hits the player. Let is keep moving across screen
