extends Node

func _ready():
	DialogueSignalBus.connect("end_dialogue", change_dialogue_stage)
	DialogueSignalBus.connect("custom_button_event", custom_button_events)

func change_dialogue_stage(npc_name, dialogue_stage, forced):
	if not forced:
		match npc_name:
			"":
				match dialogue_stage:
					"First Meet":
						GlobalDialogue.set_stage(npc_name, "First Meet")
					_:
						push_warning("dialogue_stage is not in the stage-and-event-manager")
			_:
				push_warning("npc_name is not found in the unforced forced change_dialogue_stage method of stage-and-event-manager")
	elif forced:
		match npc_name:
			"":
				match dialogue_stage:
					"First Meet":
						GlobalDialogue.set_stage(npc_name, "First Meet")
					_:
						push_warning("dialogue_stage is not in the stage-and-event-manager")
			_:
				push_warning("npc_name is not found in the forced change_dialogue_stage method of stage-and-event-manager.")
	else:
		push_warning("forced not specified.")

func custom_button_events(npc_name, dialogue_stage, flag):
	match npc_name:
		"":
			match flag:
				"close":
					DialogueSignalBus.emit_signal("alt_end_dialogue", npc_name, dialogue_stage, false)
				_:
					push_warning("flag is not found in the custom_button_events method of stage-and-event-manager.")
		_:
				push_warning("npc_name is not found in the forced custom_button_events method of stage-and-event-manager.")
