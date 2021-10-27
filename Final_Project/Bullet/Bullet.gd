extends Area2D

var speed = 750

# function for moving the bullet's position
func _physics_process(delta):
    position += transform.x * speed * delta

# function for determining if the bullet hit an enemy and freeing
func _on_Bullet_body_entered(body: Node) -> void:
  if body.is_in_group("enemy"):
    body.queue_free()
    print( "Enemy got hit by bullet" )
  elif body.is_in_group("asteroid") :
    body.queue_free()
    print( "Asteroid got hit by bullet" )
  queue_free()

# function to free the bullet once it leaves the screen (this is to avoid hitting other enemies off screen)
func _on_VisibilityNotifier2D_screen_exited() -> void:
  queue_free()
