extends Node

var stage_dictionary = {"":"First Meet"}

func get_stage(npc_name):
	print("Get Stage - ", npc_name, ": ", stage_dictionary[npc_name])
	return stage_dictionary[npc_name]

func set_stage(npc_name, new_stage):
	var old_stage = stage_dictionary[npc_name] # For debug purposes. Can delete.
	stage_dictionary[npc_name] = new_stage
	print("Old Stage - ", npc_name, ": ", old_stage)
	print("New Stage - ", npc_name, ": ", stage_dictionary[npc_name])
