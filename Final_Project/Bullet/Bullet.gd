extends Area2D

var speed = 750

# function for moving the bullet's position
func _physics_process(delta):
    position += transform.x * speed * delta



###############################################################################################################
# function for determining if the bullet hit an enemy, asteroid, or rock, adding score (if necessary) and freeing

func _on_Bullet_body_entered(body: Node) -> void:
  var ScoreLabel = get_parent().get_parent().get_node("Level/On Screen Labels/PlayerScoreNum")
  var newScore = int(float(ScoreLabel.text))
  
  if body.is_in_group("enemy"):
    newScore = newScore + 100
    ScoreLabel.text = str(newScore)
    # spawn explosion in air
    var Impact = preload("res://Asteroid/AsteroidExplosion.tscn").instance()
    body.get_parent().call_deferred("add_child", Impact)
    Impact.global_position = body.global_position
    Impact.set_scale(body.get_scale())
    body.queue_free()
    print( "Enemy got hit by bullet" )
  
  elif body.is_in_group("asteroid") :
    newScore = newScore + 10
    ScoreLabel.text = str(newScore)
    # spawn explosion in air
    var Impact = preload("res://Asteroid/AsteroidExplosion.tscn").instance()
    body.get_parent().call_deferred("add_child", Impact)
    Impact.global_position = body.global_position
    Impact.set_scale(body.get_scale())
    body.queue_free()
    print( "Asteroid got hit by bullet" )
    
  elif body.is_in_group("rock") :
   body.queue_free()
  
  # the line below is not supposed to be part of an if or elif, so please do not put it in there again
  queue_free()

###############################################################################################################



###############################################################################################################
# function to free the bullet once it leaves the screen (this is to avoid hitting other objects off screen)

func _on_VisibilityNotifier2D_screen_exited() -> void:
  queue_free()
