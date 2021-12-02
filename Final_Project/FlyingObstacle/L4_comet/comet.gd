extends KinematicBody2D

# How fast the astroid should travel
var TravelVector = Vector2( -1500, 1200 )

# Called when the node enters the scene tree for the first time.
func _ready():
    show()
    
    var Scale = rand_range(0.8, 1.2)
  
    $Anchor.set_scale( Vector2(Scale, Scale) )
    $cometShadow.set_scale( Vector2(Scale, Scale) )
    

func _process(delta):
  
  # Move asteroid by delta
  position = position + TravelVector * delta
  
  # Since the shadow moves by relative location, only need to shorten the y
  $cometShadow.position.y -= TravelVector.y * delta

func _on_ShadowDetector_body_entered( body : Node ) -> void :
  
  # Only shadows should interact with 
  if is_a_parent_of(body) :
    on_explode($cometShadow)
    
    queue_free()

func on_explode(body : Node) :
  
  var Impact = preload("res://FlyingObstacle/L4_comet/cometExplosion.tscn").instance()
  get_parent().call_deferred("add_child", Impact)
  Impact.global_position = body.global_position
  Impact.set_scale(get_scale())

  #var mineNode = preload("res://GndObstacle/L4_mine/mine.tscn").instance()
  #get_parent().get_parent().add_child(mineNode)
  #mineNode.position = position + global_position
