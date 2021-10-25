extends Node

func _ready() -> void :
  # We don't want the same random numbers each time.
  randomize()
  # Start the background music playing.
  $BackgndMusic.play()
  
# Runs whenever there is input.  This allows us to check for
#   input when it happens, rather than checking on every frame
#   in the _physics_process().
func _input( event : InputEvent ) -> void :
  # If the user wants out, just end the game.
  if event.is_action_pressed( "ui_cancel" ) :
    get_tree().quit( 0 )
