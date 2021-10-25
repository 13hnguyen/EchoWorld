extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var Timer = 1.0
var SinceSpawn = 0.0
var Spawn = Vector2(100, 100)

# Called when the node enters the scene tree for the first time.
func _ready():
  SinceSpawn = Timer


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  SinceSpawn -= delta
  
  if SinceSpawn <= 0 :
    var EnemyNode = preload("res://Enemy.tscn").instance()
    
    EnemyNode.position = Spawn
    
    add_child(EnemyNode)
    
    SinceSpawn = Timer
  
#  pass
