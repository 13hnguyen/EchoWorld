extends Area2D

# "cycleY" is how far up and down the prize will wiggle.
export var cycleY : =  25.0

# How fast the prize wiggles up and down.
export var speedY : =  75.0

# A place to keep the starting Y position of this prize.  We use
#   this as the center around which the prize wiggles.
var origY : =   0.0

# Gets run when the prize is added to the scene.
func _ready() -> void :
  # Slightly twiddle the cycle distance and speed of this prize
  #   to minimize the chance of synchronization.  Randomly set the
  #   initial direction by multiplying the speed by -1 in 50% of
  #   the cases.
  cycleY += rand_range( -2, +2 )
  speedY += rand_range( -4, +4 )

  speedY *= ( -1 if randf() > 0.5 else 1 )

  # Remember the original Y position of the prize so we can keep
  #   its motion centered around it.
  origY = position.y

  # Put this prize at a random position in its wiggle cycle.  We
  #   don't want all of the prizes to start in the middle of their
  #   wiggle cycles.
  position.y += rand_range( -cycleY, +cycleY )

# Gets run each frame.
func _physics_process( delta : float ) -> void :
  # Advance the Y position of this prize according to its speed
  #   and the amount of time that's passed ("delta").
  position.y += speedY * delta

  # If the Y position of this prize has finally gotten at least
  #   "cycleY" units away from the prize's starting Y position,
  #   negate the speed so the prize starts going in the opposite
  #   direction.
  if abs( position.y - origY ) >= cycleY :
    speedY *= -1

# The only body that could possibly enter is the Player.  (Why is
#   that so?)  When that happens, the Player has "grabbed" this
#   prize, so we queue_free it.
func _on_Prize_body_entered( _body : PhysicsBody2D ) -> void :
  print( "Player grabbed a Prize." )

  queue_free()
