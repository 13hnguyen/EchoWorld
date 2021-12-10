extends StaticBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
    show()
    

func _on_PlayerDetector_body_entered( body : Node) -> void:
    #if ! body.is_in_group("bullet") :
        #delete_collision()
        #$PlayerDetector.queue_free()
    if body.is_in_group("player") :
        #print("Player hit a mine.  deleting mine")
        
        var Impact = preload("res://FlyingObstacle/L4_comet/cometExplosion.tscn").instance()
        get_parent().call_deferred("add_child", Impact)
        Impact.global_position = body.global_position
        Impact.set_scale(get_scale())
        
        $PlayerDetector.queue_free()
        queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
