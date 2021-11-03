extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var DeathAlpha = 0.1

# Called when the node enters the scene tree for the first time.
func _ready():
  pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
 
  var Mod = lerp(get_modulate(), Color(1,1,1,0), 0.08)
  set_modulate(Mod)
  
  if $CollsionShape2D == null :
    return
  
  # free the collision shape and player detector, no need to hit player more than once
  if Mod.a <= 0.5 and Mod.a >= DeathAlpha:
    $CollisionShape2D.queue_free()
    $PlayerDetector.queue_free()
    
  elif Mod.a < DeathAlpha :
    queue_free()


func _on_PlayerDetector_body_entered( body : Node ):
  
  # free the collision shape and player detector, no need to hit player more than once
  if ! body.is_in_group("bullet") :
    $CollisionShape2D.queue_free()
    $PlayerDetector.queue_free()
