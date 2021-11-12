extends HSlider


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var audio_bus_name := "Master"

onready var _bus := AudioServer.get_bus_index(audio_bus_name)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    value = db2linear(AudioServer.get_bus_volume_db(_bus))
    # Replace with function body.
func _on_value_changed(value: float) -> void:
    AudioServer.set_bus_volume_db(_bus, linear2db(value))

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
