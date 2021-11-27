extends KinematicBody2D

# How fast the astroid should travel
var TravelVector = Vector2( -1500, 1200 )

var Scale1 = 0.8
var Scale2 = 1.2
var ScaleUp = Vector2(Scale2, Scale1)
var ScaleSide = Vector2(Scale1, Scale2)

# determine how fast per lerp call the scales should move
var ScaleLerp = 0.1

# determine how many process calls until scales have ended
var ScaleLerpEnd = (Scale2 - Scale1) / ScaleLerp

# keeps track of far we have interpolated
var ScaleValue = 0


var ScaleUpCurrent = false

# Called when the node enters the scene tree for the first time.
func _ready():
  show()
  # Variate the asteroid trajectories
  TravelVector.x += rand_range(-300,300)
  TravelVector.y += rand_range(-200,200)
  
  ScaleUpCurrent = rand_range(0, 1) > 0.5
  
  $Anchor.set_scale( ScaleUp if ScaleUpCurrent else ScaleSide )
  $IceBallShadow.set_scale( ScaleUp if ScaleUpCurrent else ScaleSide )

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  # Move asteroid by delta
  position = position + TravelVector * delta
  
  # Since the shadow moves by relative location, only need to shorten the y
  $IceBallShadow.position.y -= TravelVector.y * delta
  
  # $Anchor/SpriteBlaze.set_modulate(lerp($Anchor/SpriteBlaze.get_modulate(), Color(1,0,0,1), 0.01))
  if ScaleUpCurrent :
    $Anchor.set_scale( lerp($Anchor.get_scale(), ScaleSide, ScaleLerp) );
    $IceBallShadow.set_scale( lerp($IceBallShadow.get_scale(), ScaleSide, ScaleLerp) );
  else :
    $Anchor.set_scale( lerp($Anchor.get_scale(), ScaleUp, ScaleLerp) );
    $IceBallShadow.set_scale( lerp($IceBallShadow.get_scale(), ScaleUp, ScaleLerp) );
    
  ScaleValue += ScaleLerp
  
  if ScaleValue >= ScaleLerpEnd :
    ScaleValue = 0
    ScaleUpCurrent = !ScaleUpCurrent
  
  
func _on_ShadowDetector_body_entered( body : Node ) -> void :
  # Only shadows should interact with 
  if is_a_parent_of(body) :
    on_explode($IceBallShadow)
    
    queue_free()
    
# explosion method called by shadow detector or the bullet that hits it
func on_explode(body : Node) :
  var Impact = preload("res://FlyingObstacle/L3_iceball/IceBallExplosion.tscn").instance()
  get_parent().call_deferred("add_child", Impact)
  Impact.global_position = body.global_position
  Impact.set_scale(get_scale())
