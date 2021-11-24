extends KinematicBody2D

var speed    : = 300.0
var healthPoints : = 100
var movement : Vector2

func _ready() -> void:
  if GameData.tryAgain == true: #sets the players health to 3 if they die and restart
    healthPoints = 100
#######################################################################################################
# CHARACTER MOVEMENT AND SHOOTING BULLETS
##########################################################################################################

# load the bullet scene
var bullet = load("res://Bullet/PlayerBullet/Bullet.tscn")

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

  movement = speed * direction * delta
  var _velocity = move_and_collide(movement) # velocity has an underscore on purpose




##########################################################################################################
# CHARACTER HEALTH SYSYTEM
##########################################################################################################

# function to detect whether the player has been hit by another 2D Body (ie. asteroid or rock)
func _on_EnemyDetector_body_entered( body : Node ) -> void :
  print( "Player got hit by 2D body. Type: ", body )
  healthPoints = healthPoints - 1
  var HealthLabel = get_parent().get_node("On Screen Labels/PlayerHP")
  HealthLabel.text = str(healthPoints)
  
  if body.is_in_group("explosion") :
    body.call_deferred("delete_collision")
  
  checkHealth()

# function to detect whether the player has been hit by another Area 2D (ie. enemy bullet, portal, explosion)
func _on_EnemyDetector_area_entered( area: Area2D) -> void:
  # make sure asteroid explosions only count once
  if area.get_parent().is_in_group("explosion") :
    return
  if area.is_in_group("portal") :
    return
  
  print ( "Player got hit by 2D area. Type: ", area )
  healthPoints = healthPoints - 1
  var HealthLabel = get_parent().get_node("On Screen Labels/PlayerHP")
  HealthLabel.text = str(healthPoints)
  checkHealth()

# function to determine if the health of the player == 0 (meaning the player died)
func checkHealth () -> void :
  if(healthPoints < 1) :
    var _scene = get_tree().change_scene("res://Menus/GameOverMenu.tscn")




##########################################################################################################
# CHARACTER ENTER PORTAL TO CHANGE LEVELS
##########################################################################################################

func gotoScene( which : int = -1 ) -> void :
  GameData.savePlayerObj.level = which; # update the level for the player
  #print("Level")
  #print(GameData.savePlayerObj.level)
  GameData.savePlayerData(); # call function in gamedata.gd to save player data when a portal is reached
  var _scene = get_tree().change_scene("res://Menus/PlanetMenu.tscn")

