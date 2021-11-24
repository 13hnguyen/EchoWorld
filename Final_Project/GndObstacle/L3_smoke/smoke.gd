extends StaticBody2D


#for the fire to burn
func _ready():
    get_node("AnimationFire").play("fire")

