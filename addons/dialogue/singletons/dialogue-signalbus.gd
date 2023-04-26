extends Node

signal start_dialogue(npc_name, dialogue_stage, dialogue_file)

signal next_dialogue(npc_name, dialogue_stage)

signal end_dialogue(npc_name, dialogue_stage, forced)

signal alt_end_dialogue(npc_name, dialogue_stage, forced)

signal custom_button_event(npc_name, dialogue_stage, flag)
