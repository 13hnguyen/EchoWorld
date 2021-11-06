extends KinematicBody2D

# How fast the astroid should travel
var TravelVector = Vector2( -1500, 1200 )

# Called when the node enters the scene tree for the first time.
func _ready():
  
  show()
  # Variate the asteroid trajectories
  TravelVector.x += rand_range(-300,300)
  TravelVector.y += rand_range(-200,200)
  
  var Rotation = rand_range(-30, 30)
  $Anchor.set_rotation_degrees( Rotation )
  
  var Scale = rand_range(0.8, 1.2)
  
  $Anchor.set_scale( Vector2(Scale, Scale) )
  $Shadow.set_scale( Vector2(Scale, Scale) )
  
  $Trail.set_rotation_degrees( rad2deg( atan(TravelVector.y / TravelVector.x) ) )
  $Trail.set_scale( Scale * $Trail.get_scale() )
  $Trail.position *= Scale

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  
  # Move asteroid by delta
  position = position + TravelVector * delta
  
  # Since the shadow moves by relative location, only need to shorten the y
  $Shadow.position.y -= TravelVector.y * delta
  
  # Slowly make front of asteroid burn red
  $Anchor/SpriteBlaze.set_modulate(lerp($Anchor/SpriteBlaze.get_modulate(), Color(1,0,0,1), 0.01))
  
func _on_ShadowDetector_body_entered( body : Node ) -> void :
  
  # Only shadows should interact with 
  if is_a_parent_of(body) :
    
    var Impact = preload("res://Asteroid/AsteroidExplosion.tscn").instance()
    get_parent().add_child(Impact)
    Impact.global_position = $Shadow.global_position
    Impact.set_scale(get_scale())
    
    queue_free()
