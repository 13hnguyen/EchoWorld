extends TextureRect

export var speed : = 0.1

#-----------------------------------------------------------------
func _ready() -> void :
  # Duplicate the material so that when we change its speed, we
  #   don't change the speed of all OTHER InfiniteScroll nodes.
  material = material.duplicate()

  setSpeed( speed )

#-----------------------------------------------------------------
func setSpeed( newSpeed : float ) -> void :
  material.set_shader_param( "speed", newSpeed )

#-----------------------------------------------------------------
