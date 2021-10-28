extends KinematicBody2D
#elevation of saucers
var gravity  : = -0.5
#speed of saucer
var speed    : = Vector2( 450.0, 50.0 )
var velocity : = Vector2.ZERO

func _ready() -> void:
  velocity.x = -speed.x

func _physics_process(delta: float) -> void:
  velocity.y += gravity * delta
  velocity.y = move_and_slide( velocity, Vector2.UP ).y
  velocity.x *= -1 if is_on_wall() else 1
