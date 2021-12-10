extends Area2D

var speed = 500

# function for moving the bullet's position
func _physics_process(delta):
    position += transform.x * speed * delta

# function for determining if the bullet hit player
func _on_EnemyBullet_body_entered(body: Node) -> void:
  if body.is_in_group("player"):
    #print("enemy bullet hit player")
    queue_free()

# function to free the bullet once it leaves the screen (this is to avoid hitting other objects off screen)
func _on_VisibilityNotifier2D_screen_exited() -> void:
  queue_free()
