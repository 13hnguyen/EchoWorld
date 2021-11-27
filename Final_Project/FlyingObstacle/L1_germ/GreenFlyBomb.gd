extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var velocity : = Vector2.ZERO
var gravity = 500.0

var canFall = false

var GroundMin = 840 
var GroundMax = 1000

# Called when the node enters the scene tree for the first time.
func _ready():
  $Shadow.hide()

func fall_now(direction : float) :
  canFall = true
  velocity.x = direction
  $Shadow.position = Vector2( 0, rand_range(GroundMin, GroundMax) - global_position.y )
  $Shadow.show()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  
  if canFall :
    velocity.y += gravity * delta
    
    var posY = position.y
    velocity.y = move_and_slide(velocity, Vector2.UP).y
    var deltaY = position.y - posY
    
    $Shadow.position.y -= deltaY


func _on_ShadowDetector_body_entered(body):
  
  if is_a_parent_of(body) :
    var Impact = preload("res://FlyingObstacle/L1_germ/GermExplosion.tscn").instance()
    get_parent().call_deferred("add_child", Impact)
    Impact.global_position = $Shadow.global_position
    Impact.set_scale(get_scale())
    queue_free()
