extends Area2D

var in_area = false
var in_dialogue = false

@export var npc_name = ""
@export_file var dialogue_file = "res://addons/dialogue/default-dialogue.json"

func _ready():
	DialogueSignalBus.connect("end_dialogue", end_dialogue)

func _input(event):
	if event.is_action_pressed("ui_select") and in_area and not in_dialogue:
		in_dialogue = true
		
		DialogueSignalBus.emit_signal("start_dialogue", npc_name, GlobalDialogue.get_stage(npc_name), dialogue_file)
	elif event.is_action_pressed("ui_select") and in_area and in_dialogue:
		DialogueSignalBus.emit_signal("next_dialogue", npc_name, GlobalDialogue.get_stage(npc_name))

func end_dialogue(_passed_npc_name, _dialogue_stage, _forced):
	in_dialogue = false

func _on_area_entered(_area):
	in_area = true
	print("Player entered area around ", npc_name)

func _on_area_exited(_area):
	in_area = false
	DialogueSignalBus.emit_signal("alt_end_dialogue", npc_name, GlobalDialogue.get_stage(npc_name), true)
	print("Player left area around ", npc_name)
