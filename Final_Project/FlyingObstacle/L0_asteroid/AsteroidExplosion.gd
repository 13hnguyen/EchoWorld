extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var DeathAlpha = 0.2

var ChildCount = 0

# Called when the node enters the scene tree for the first time.
func _ready():
  $Explosion.play()
  ChildCount = get_child_count()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
 
  var Mod = lerp($Sprite.get_modulate(), Color(1,1,1,0), 0.08)
  $Sprite.set_modulate(Mod)
  
  # free the collision shape and player detector, no need to hit player more than once
  if Mod.a <= 0.5 and Mod.a >= DeathAlpha:
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
