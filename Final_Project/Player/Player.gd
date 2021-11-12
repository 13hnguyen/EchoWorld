extends KinematicBody2D

var speed    : = 300.0
var healthPoints : = 3

func _ready() -> void:
  if GameData.loadGame == false:
    GameData.savePlayerObj.health = healthPoints; # set the initial health points for the player
    #print("Health:")
    #print(GameData.savePlayerObj.health)


##########################################################################################################
# CHARACTER MOVEMENT AND SHOOTING BULLETS
##########################################################################################################

# load the bullet scene
var bullet = load("res://Bullet/Bullet.tscn")

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

# function for player movement: left, right, up, down, diagonal
func _physics_process( delta : float ) -> void :
  get_node("AnimationPlayer").play("wheels")
  var direction: Vector2
  direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
  direction.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")

  # if input is digital, normalize it for diagonal movement
  if abs(direction.x) == 1 and abs(direction.y) == 1:
    direction = direction.normalized()

  var movement = speed * direction * delta
  var _velocity = move_and_collide(movement) # velocity has an underscore on purpose




##########################################################################################################
# CHARACTER HEALTH SYSYTEM
##########################################################################################################

# function to detect whether the player has been hit by another 2D Kinematic Body (ie. asteroid)
func _on_EnemyDetector_body_entered( _body : Node ) -> void :
  print( "Player got hit by 2D body." )
  healthPoints = healthPoints - 1
  var HealthLabel = get_parent().get_node("On Screen Labels/PlayerHP")
  HealthLabel.text = str(healthPoints)
  GameData.savePlayerObj.health = healthPoints; # update the health points for the player
  checkHealth()
  #print("Health:")
  #print(GameData.savePlayerObj.health)

# function to detect whether the player has been hit by another Area 2D (ie. alien bullet)
func _on_EnemyDetector_area_entered( area: Area2D) -> void:
  # make sure asteroid explosions only count once
  if area.get_parent().is_in_group("explosion") :
    return
  
  print ( "Player got hit by 2D area." )
  healthPoints = healthPoints - 1
  var HealthLabel = get_parent().get_node("On Screen Labels/PlayerHP")
  HealthLabel.text = str(healthPoints)
  GameData.savePlayerObj.health = healthPoints; # update the health points for the player
  checkHealth()

# function to determine if the health of the player == 0 (meaning the player died)
func checkHealth () -> void :
  if(healthPoints == 0) :
    print("Player health = 0. JP your code should go here for player dying")




##########################################################################################################
# CHARACTER ENTER PORTAL TO CHANGE LEVELS
##########################################################################################################

# code below is to handle loading different levels when the player reaches a portal
const level = [
  { 'StartPosition' : Vector2(  120 , 950 ), 'CameraLimits' : [  -64, 3984 ] }
  # repeat object above inside this array when we starting adding new levels
  ]

#var currentLevel : = 0

func gotoScene( which : int = -1 ) -> void :
  GameData.savePlayerObj.level = which; # update the level for the player
  #print("Level")
  #print(GameData.savePlayerObj.level)
  GameData.savePlayerData(); # call function in gamedata.gd to save player data when a portal is reached
  var _scene = get_tree().change_scene("res://Menus/PlanetMenu.tscn")
  
  #if which < 0 :
    #which = currentLevel

  #if which >= level.size() :
    #print( "Finished last level, so going back to the beginning." )
    #which = 0
  #position = level[which][ 'StartPosition' ]
  #$Camera2D.limit_left  = level[which][ 'CameraLimits' ][0]
  #$Camera2D.limit_right = level[which][ 'CameraLimits' ][1]


func _on_ObstacleDetector_body_entered(body):
  print( "Player got hit by a Rock." )
  
  healthPoints = healthPoints - 1
  var HealthLabel = get_parent().get_node("On Screen Labels/PlayerHP")
  HealthLabel.text = str(healthPoints)
  GameData.savePlayerObj.health = healthPoints; # update the health points for the player
  #print("Health:")
  #print(GameData.savePlayerObj.health)
  if(healthPoints == 0) :
    # removed old code that called goToLevel when health = 0. the goToLevel should only be called when you enter a PORTAL. it should never be called at any other time.
    # when hp = 0, show popup die accept dialog screen and exit to main menu
    
    print("Player health = 0. JP your code should go here for player dying")
