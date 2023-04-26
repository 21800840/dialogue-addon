extends CanvasLayer

var dialogue_dictionary: Dictionary
var stage_size: int
var option_amount: int
var current_stage: int
var passed_npc_name: String
var passed_dialogue_stage: String
var has_options: bool

func _ready():
	DialogueSignalBus.connect("start_dialogue", start_dialogue)
	DialogueSignalBus.connect("next_dialogue", next_dialogue)
	DialogueSignalBus.connect("alt_end_dialogue", end_dialogue)

func start_dialogue(npc_name, dialogue_stage, dialogue_file):
	print("Start Dialogue with ", npc_name, " at ", dialogue_stage, " with ", dialogue_file)
	
	# Reset variables on start
	dialogue_dictionary.clear()
	stage_size = 0
	option_amount = 0
	current_stage = 0
	has_options = false
	
	# Make variables passed from other other script global.
	passed_npc_name = npc_name
	passed_dialogue_stage = dialogue_stage
	
	parse_json(dialogue_file)
	
	set_stage_size(npc_name, dialogue_stage)
	
	next_dialogue(npc_name, dialogue_stage)

func parse_json(dialogue_file):
	dialogue_dictionary = JSON.parse_string(FileAccess.open(dialogue_file, FileAccess.READ).get_as_text())
	
	print(dialogue_dictionary)


func set_stage_size(npc_name, dialogue_stage):
	stage_size = dialogue_dictionary[dialogue_stage].size()
	
	print(stage_size)

func set_option_amount(npc_name, dialogue_stage):
	if dialogue_dictionary[dialogue_stage][str(current_stage)].has("options"):
		match dialogue_dictionary[dialogue_stage][str(current_stage)]["options"].size():
			0:
				option_amount = 0
				print("0 options")
			1:
				option_amount = 1
				print("1 Option")
			2:
				option_amount = 2
				print("2 options")
			_:
				option_amount = 0
				push_warning("Error setting option amount. Option amount could be set too high, or too low.")
	else:
		option_amount = 0
		print("No options")

func next_dialogue(npc_name, dialogue_stage):
	if current_stage < stage_size:
		set_option_amount(npc_name, dialogue_stage)
		match option_amount:
			0:
				$NoOptions.visible = true
				$OneOption.visible = false
				$TwoOptions.visible = false
				$NoOptions/TextureRect/NameLabel.text = dialogue_dictionary[dialogue_stage][str(current_stage)]["name"]
				$NoOptions/TextureRect/TextLabel.text = dialogue_dictionary[dialogue_stage][str(current_stage)]["text"]
			1:
				$OneOption.visible = true
				$NoOptions.visible = false
				$TwoOptions.visible = false
				$OneOption/TextureRect/NameLabel.text = dialogue_dictionary[dialogue_stage][str(current_stage)]["name"]
				$OneOption/TextureRect/TextLabel.text = dialogue_dictionary[dialogue_stage][str(current_stage)]["text"]
				$OneOption/OneOptionButton.text = dialogue_dictionary[dialogue_stage][str(current_stage)]["options"]["option 1"]["text"]
				$OneOption/OneOptionButton.set_meta("flag", dialogue_dictionary[dialogue_stage][str(current_stage)]["options"]["option 1"]["flag"])
				has_options = true
			2:
				$TwoOptions.visible = true
				$NoOptions.visible = false
				$OneOption.visible = false
				$TwoOptions/TextureRect/NameLabel.text = dialogue_dictionary[dialogue_stage][str(current_stage)]["name"]
				$TwoOptions/TextureRect/TextLabel.text = dialogue_dictionary[dialogue_stage][str(current_stage)]["text"]
				$TwoOptions/TwoOptionsButton.text = dialogue_dictionary[dialogue_stage][str(current_stage)]["options"]["option 1"]["text"]
				$TwoOptions/TwoOptionsButton.set_meta("flag", dialogue_dictionary[dialogue_stage][str(current_stage)]["options"]["option 1"]["flag"])
				$TwoOptions/TwoOptionsButton2.text = dialogue_dictionary[dialogue_stage][str(current_stage)]["options"]["option 2"]["text"]
				$TwoOptions/TwoOptionsButton2.set_meta("flag", dialogue_dictionary[dialogue_stage][str(current_stage)]["options"]["option 2"]["flag"])
				has_options = true
	else:
		end_dialogue(npc_name, dialogue_stage, false)
		return
	
	if has_options:
		return
	current_stage += 1

func end_dialogue(npc_name, dialogue_stage, forced):
	current_stage = 0
	
	DialogueSignalBus.emit_signal("end_dialogue", npc_name, dialogue_stage, forced)
	
	match option_amount:
		0:
			$NoOptions.visible = false
		1:
			$OneOption.visible = false
		2:
			$TwoOptions.visible = false
		_:
			push_warning("Tried to hide none existant dialogue.")

func button_manager(button_pressed):
	match button_pressed.get_meta("flag"):
		"leave":
			end_dialogue(passed_npc_name, passed_dialogue_stage, false)
			print("Leave")
		"shop":
			print("Shop")
		"get":
			print("Get")
		"set":
			print("Set")
		"next":
			current_stage += 1
			has_options = false
			next_dialogue(passed_npc_name, passed_dialogue_stage)
			print("Next")
		_:
			DialogueSignalBus.emit_signal("custom_button_event", passed_npc_name, passed_dialogue_stage, button_pressed.get_meta("flag"))
		
	has_options = false

func _on_one_option_button_pressed():
	var button_pressed = $OneOption/OneOptionButton
	button_manager(button_pressed)

func _on_two_options_button_pressed():
	var button_pressed = $TwoOptions/TwoOptionsButton
	button_manager(button_pressed)

func _on_two_options_button_2_pressed():
	var button_pressed = $TwoOptions/TwoOptionsButton2
	button_manager(button_pressed)
