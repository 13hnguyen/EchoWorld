extends KinematicBody2D
#elevation of saucers
var gravity  : = -10.0
#speed of saucer
var speed    : = Vector2( 450.0, 50.0 )
var velocity : = Vector2.ZERO

var currentBomb = null;

var DropTimer

# load the bomb scene
var bomb = preload("res://FlyingObstacle/L1_germ/GreenFlyBomb.tscn")

func _ready() -> void:
  velocity.x = -speed.x

func _physics_process(delta: float) -> void:
  get_node("AnimationPlayer").play("Flying")
  velocity.y += gravity * delta
  velocity.y = move_and_slide( velocity, Vector2.UP ).y
  velocity.x *= -1 if is_on_wall() else 1
  
  if currentBomb != null :
    currentBomb.set_scale( lerp(currentBomb.get_scale(), Vector2(1,1), 0.05) );
    
    if currentBomb.get_scale().x >= 0.9 :
      remove_child(currentBomb)
      get_tree().get_root().add_child(currentBomb)
      currentBomb.global_transform = $BombDownSpawnPos.global_transform
      currentBomb.call_deferred("fall_now", -150 if velocity.x < 0 else 150);
      currentBomb = null
    

func _on_BulletShootTimer_timeout() -> void:
  #print("alien shoot bullet")
  fire()

func fire () -> void:
  currentBomb = bomb.instance()
  add_child(currentBomb)
  currentBomb.transform = $BombDownSpawnPos.transform
  currentBomb.set_scale(Vector2(0,0));

func _on_VisibilityNotifier2D_screen_exited() -> void:
  print("enemy left screen. free enemy.")
  queue_free()
