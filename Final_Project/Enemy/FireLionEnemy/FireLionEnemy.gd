extends KinematicBody2D

#elevation of saucers
var gravity  : = -100.0
#speed of saucer
var speed    : = Vector2( 450.0, 50.0 )
var velocity : = Vector2.ZERO

# load the bullet scene
var bullet = load("res://Bullet/EnemyBullets/BeeBullet/BeeBullet.tscn")

func _ready() -> void:
  #velocity.x = -speed.x
  velocity.y = speed.y

func _physics_process(delta: float) -> void:
  get_node("AnimationPlayer").play("Flashlights")
  velocity.y += gravity * delta
  velocity.y = move_and_slide( velocity, Vector2.UP ).y
  #velocity.x *= -1 if is_on_wall() else 1

func _on_BulletShootTimer_timeout() -> void:
  #print("alien shoot bullet")
  fire()

func fire () -> void:
  var b = bullet.instance()
  get_tree().get_root().add_child(b)
  b.transform = $BulletSpawnLocation.global_transform

func _on_VisibilityNotifier2D_screen_exited() -> void:
  print("enemy left screen. free enemy.")
  queue_free()
