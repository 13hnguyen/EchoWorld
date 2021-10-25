extends KinematicBody2D

var gravity  : = 3000.0
var speed    : = Vector2( 300.0, 1250.0 )
var stompImpluse : = 800.0
var velocity : = Vector2.ZERO

# load the bullet scene
var bullet = preload("res://Bullet/Bullet.tscn")

# looking for input to signal that the player shoots a bullet
func _input( event : InputEvent ) -> void :
  if event.is_action_pressed( "shootRight" ) :
    shootRight()
  elif event.is_action_pressed( "shootUp" ) :
    shootUp()

# function to handle creating an instance of the bullet when player shoots RIGHT
func shootRight():
  var b = bullet.instance()
  owner.add_child(b)
  b.transform = $BulletRightSpawnPos.global_transform

# function to handle creating an instance of the bullet when player shoots UP
func shootUp():
  var b = bullet.instance()
  owner.add_child(b)
  b.transform = $BulletUpSpawnPos.global_transform
  b.rotation = $BulletUpSpawnPos.global_rotation

func _physics_process( delta : float ) -> void :
  var isJumpInterrupted : = Input.is_action_just_released("jump") and velocity.y < 0.0

  var direction : = Vector2(
    Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
    -1 if Input.is_action_just_pressed("jump") and is_on_floor() else 1
   )

  velocity.x = speed.x * direction.x

  if isJumpInterrupted :
    velocity.y = 0.0

  elif direction.y == -1 :
    velocity.y = -speed.y

  else :
    velocity.y += gravity * delta

  velocity = move_and_slide( velocity, Vector2.UP )


func _on_EnemyDetector_body_entered( _body : Node ) -> void :
  print( "Player got hit by an Enemy." )
  gotoLevel()

func _on_StompDetector_body_entered( _body : Node ) -> void :
  velocity.y = -stompImpluse

const level = [
  { 'StartPosition' : Vector2(  163, 181 ), 'CameraLimits' : [  -64, 3984 ] }
  # repeat object above inside this array when we starting adding new levels
  ]

var currentLevel : = 0

func gotoLevel( which : int = -1 ) -> void :
  if which < 0 :
    which = currentLevel

  if which >= level.size() :
    print( "Finished last level, so going back to the beginning." )
    which = 0
  position = level[which][ 'StartPosition' ]
  $Camera2D.limit_left  = level[which][ 'CameraLimits' ][0]
  $Camera2D.limit_right = level[which][ 'CameraLimits' ][1]

#-----------------------------------------------------------------
