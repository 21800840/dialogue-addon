@tool
extends EditorPlugin

const AUTOLOAD_DIALOGUE_SIGNALBUS = "DialogueSignalBus"
const AUTOLOAD_GLOBAL_DIALOGUE = "GlobalDialogue"

func _enter_tree():
	add_autoload_singleton(AUTOLOAD_DIALOGUE_SIGNALBUS, "res://addons/dialogue/singletons/dialogue-signalbus.gd")
	add_autoload_singleton(AUTOLOAD_GLOBAL_DIALOGUE, "res://addons/dialogue/singletons/global-dialogue.gd")
	
	ProjectSettings.set_setting("layer_names/2d_physics/layer_2", "Dialogue") # Check (loop) for first unnamed layer and set self to that?

func _exit_tree():
	remove_autoload_singleton(AUTOLOAD_DIALOGUE_SIGNALBUS)
	remove_autoload_singleton(AUTOLOAD_GLOBAL_DIALOGUE)
