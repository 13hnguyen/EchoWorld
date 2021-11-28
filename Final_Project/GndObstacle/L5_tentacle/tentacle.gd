extends StaticBody2D


#for the fire to burn
func _ready():
    get_node("AnimationTentacle").play("unroll")

