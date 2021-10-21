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
  queue_free()
