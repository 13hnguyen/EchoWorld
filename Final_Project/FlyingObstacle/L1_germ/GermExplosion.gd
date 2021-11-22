extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var DeleteCollisionTime = 0.2
var DeathAlpha = 0.2

var ChildCount = 0

var ShapeGone = false

# Called when the node enters the scene tree for the first time.
func _ready():
  ChildCount = get_child_count()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta : float):
 
  var Scale = $Sprite.get_scale()
  $Sprite.set_scale( Vector2(Scale.x + delta, Scale.y + delta) )
  
  var Mod = lerp($Sprite.get_modulate(), Color(1,1,1,0), 0.02)
  $Sprite.set_modulate(Mod)

  DeleteCollisionTime -= delta
  
  # free the collision shape and player detector, no need to hit player more than once
  if DeleteCollisionTime <= 0.0:
    delete_collision()
    
  elif Mod.a < DeathAlpha :
    queue_free()

func delete_collision() :
  if get_child_count() == ChildCount :
    $CollisionShape2D.queue_free()

func _on_PlayerDetector_body_entered( body : Node ):
  
  # free the collision shape and player detector, no need to hit player more than once
  if ! body.is_in_group("bullet") :
    delete_collision()
    $PlayerDetector.queue_free()
