extends Node

func _ready() -> void :
  # We don't want the same random numbers each time.
  randomize()

  # Start the asteroid generation
  var AsteroidGen = preload("res://Asteroid/AsteroidGenerator.tscn")
  var asteroidGen = AsteroidGen.instance()
  add_child(asteroidGen)

  # Start the rock generation
  var RockGen = preload("res://Rock/RockGenerator.tscn")
  var rockGen = RockGen.instance()
  add_child(rockGen)
  
  # Start the background music playing.
  $BackgndMusic.play()
  
# Runs whenever there is input.  This allows us to check for
#   input when it happens, rather than checking on every frame
#   in the _physics_process().
func _input( event : InputEvent ) -> void :
  # If the user wants out, just end the game.
  if event.is_action_pressed( "ui_cancel" ) :
    var _scene = get_tree().change_scene("res://Menus/MainMenu.tscn")
