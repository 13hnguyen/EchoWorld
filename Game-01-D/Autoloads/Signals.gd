extends Node

# Signals that can be connected to and emitted from any scene.
#   Useful for transferring control information from/to arbitrary
#   points in the game tree.

# warning-ignore:unused_signal
signal Level_has_ended( how )

# warning-ignore:unused_signal
signal Level_has_started( which )

# warning-ignore:unused_signal
signal End_level( how )

# warning-ignore:unused_signal
signal Enter_edit_mode

# warning-ignore:unused_signal
signal Exit_edit_mode

# warning-ignore:unused_signal
signal Incr_score( incr )

# warning-ignore:unused_signal
signal Start_level( level )
