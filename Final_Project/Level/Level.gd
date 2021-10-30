extends Node

func _ready() -> void :
  # We don't want the same random numbers each time.
  randomize()

  # Start the asteroid generation
  var AsteroidGen = preload("res://Asteroid/AsteroidGenerator.tscn")
  var asteroidGen = AsteroidGen.instance()
  asteroidGen.position = Vector2(1700, -100)
  
  # Add asteroid generator to canvas layer since it follows the player
  var canvasIndex = 0
  for n in range(1, get_child_count()) :
    var node = get_child(n)
    if node is CanvasLayer :
      canvasIndex = n
    
  get_child(canvasIndex).add_child(asteroidGen)

  # Start the rock generation
  var RockGen = preload("res://Rock/RockGenerator.tscn")
  var rockGen = RockGen.instance()
  rockGen.position = Vector2(2000, 870)
  
  # Add rock generator to canvas layer since it follows the player
    
  get_child(canvasIndex).add_child(rockGen)
  
  # Start the background music playing.
  $BackgndMusic.play()
  
# Runs whenever there is input.  This allows us to check for
#   input when it happens, rather than checking on every frame
#   in the _physics_process().
#func _input( event : InputEvent ) -> void :
  # If the user wants out, just end the game.
#  if event.is_action_pressed( "ui_pause" ) :
#    get_tree().paused = true
