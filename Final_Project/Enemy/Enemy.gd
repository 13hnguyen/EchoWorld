extends KinematicBody2D

var gravity  : = 3000.0
var speed    : = Vector2( 150.0, 1250.0 )
var velocity : = Vector2.ZERO

func _ready() -> void:
  velocity.x = -speed.x

func _physics_process(delta: float) -> void:
  velocity.y += gravity * delta
  velocity.y = move_and_slide( velocity, Vector2.UP ).y
  velocity.x *= -1 if is_on_wall() else 1
