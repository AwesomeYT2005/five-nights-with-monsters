extends Node2D

var VoiceLinesDict = {
	"voice1" = {
		"start": 0.65,
		"end": 4.54,
		"animation": "neutral",
		"text": "Hey kid. You seem to be having some trouble if you're dying to me. You need some advice?",
		"next_action": "choice1",
	},
	"voice2" = {
		"start": 5.248,
		"end": 8.248,
		"animation": "pissed",
		"text": "I was just trying to help. Be careful who you piss off around here.",
		"next_action": "jumpscare",
	},
	"voice3" = {
		"start": 9.937,
		"end": 11.773,
		"animation": "thoughtful",
		"text": "Why haven't I killed you YET?",
		"next_action": "voice4",
	},
	"voice4" = {
		"start": 12.91,
		"end": 17.276,
		"animation": "squinting",
		"text": "Because you seem to think that this day is different to your last.",
		"next_action": "choice2",
	},
	"voice5" = {
		"start": 18.936,
		"end": 23.696,
		"animation": "squirming",
		"text": "If I say anything else, it might melt your mind. Best not to think about it.",
		"next_action": "choice3",
	},
	"voice6" = {
		"start": 24.845,
		"end": 27.249,
		"animation": "squinting",
		"text": "Yes, but JUST THIS ONCE.",
		"next_action": "voice7",
	},
	"voice7" = {
		"start": 28.363,
		"end": 30.43,
		"animation": "squirming",
		"text": "Anymore, and I would get into trouble.",
		"next_action": "choice4",
	},
	"voice8" = {
		"start": 31.869,
		"end": 36.966,
		"animation": "thoughtful",
		"text": "He's... a bit strange, even by our standards. We don't really invite him to stuff.",
		"next_action": "voice9",
	},
	"voice9" = {
		"start": 38.812,
		"end": 43.328,
		"animation": "flat",
		"text": "Most of the time, he's just creeping around, looking into people's windows.",
		"next_action": "voice10",
	},
	"voice10" = {
		"start": 45.023,
		"end": 49.702,
		"animation": "thoughtful",
		"text": "I mean, he basically just plays peek-a-boo with you. And if he wins?",
		"next_action": "voice11",
	},
	"voice11" = {
		"start": 50.492,
		"end": 51.304,
		"animation": "pissed",
		"text": "He eats you.",
		"next_action": "choice5",
	},
	"voice12" = {
		"start": 52.431,
		"end": 57.667,
		"animation": "squinting",
		"text": "Oh right so our INTERPERSONAL relationships aren't important to you? I see how it is.",
		"next_action": "voice13",
	},
	"voice13" = {
		"start": 58.561,
		"end": 61.707,
		"animation": "look_left",
		"text": "Well, he hates the light. That's why he strikes at night.",
		"next_action": "voice14",
	},
	"voice14" = {
		"start": 62.346,
		"end": 63.948,
		"animation": "flat",
		"text": "That, and he knows its creepier.",
		"next_action": "choice6", 
		# This choice leads to the end sequence of the encounter.
	},
	"voice15" = {
		"start": 65.875,
		"end": 69.706,
		"animation": "look_down",
		"text": "The Doorman? I can't really say much about him.",
		"next_action": "choice7",
	},
	"voice16" = {
		"start": 69.8,
		"end": 72.8,
		"animation": "look_down",
		"text": "...",
		"next_action": "choice8",
	},
	"voice17" = {
		"start": 72.957,
		"end": 74.861,
		"animation": "ashamed",
		"text": "After three knocks, THE WARDROBE.",
		"next_action": "choice6", 
		# This needs to play the 'look_around' animation after, and "..." after.
	},
	"voice18" = {
		"start": 77.357,
		"end": 81.839,
		"animation": "squirming",
		"text": "HA HA, if you've still not figured that out, you've... not got a chance.",
		"next_action": "choice9",
	},
	"voice19" = {
		"start": 83.487,
		"end": 85.925,
		"animation": "look_right",
		"text": "Look through the cameras. You'll... see what I mean.",
		"next_action": "choice6",
	},
	"voice20" = {
		"start": 86.796,
		"end": 90.012,
		"animation": "pissed",
		"text": "And YOU shouldn't forget who you're talking to.",
		"next_action": "jumpscare",
	},
	"voice21" = {
		"start": 91.312,
		"end": 93.135,
		"animation": "look_down",
		"text": "You... really wanna know about me?",
		"next_action": "choice10",
	},
	"voice22" = {
		"start": 94.935,
		"end": 97.048,
		"animation": "pissed",
		"text": "Aaaaaaand now you've pissed me off.",
		"next_action": "jumpscare",
	},
	"voice23" = {
		# Play 'closed' before playing these voicelines
		"start": 98.662,
		"end": 104.281,
		"animation": "pissed",
		"text": "MY NAME IS PHANTASMO ELIXTERSON REGINALD DRAVENOR XV!",
		"next_action": "voice24",
	},
	"voice24" = {
		"start": 105.442,
		"end": 111.862,
		"animation": "pissed",
		"text": "I COME FROM A LONG LINE OF PROUD DRAVENORS THAT HAVE HAUNTED YOUR MINDS FOR GENERATIONS.",
		"next_action": "voice25",
	},
	"voice25" = {
		"start": 113.209,
		"end": 122.880,
		"animation": "pissed",
		"text": "MY FAMILY NAME HAS STRUCK FEAR IN DEMONOLOGISTS FOR CENTURIES AND WILL CONTINUE TO DO SO UNTIL THE INEVITABLE FALL OF--",
		"next_action": "voice26",
	},
	"voice26" = {
		# Play 'closed' before this again.
		"start": 126.142,
		"end": 130.786,
		"animation": "flat",
		"text": "I mean, I enjoy pinacoladas, getting caught in the rain and I hate yoga.",
		"next_action": "choice11",
	},
	"voice27" = {
		"start": 131.611,
		"end": 136.684,
		"animation": "squinting",
		"text": "I think... any human who doesn't get that reference wasted their life anyways.",
		"next_action": "jumpscare",
	},
	"voice28" = {
		"start": 139.413,
		"end": 142.710,
		"animation": "thoughtful",
		"text": "My Father used to tell people, just before he killed them:",
		"next_action": "voice29",
	},
	"voice29" = {
		"start": 143.732,
		"end": 150.442,
		"animation": "closed",
		"text": "HE WHO GAZES UPON DEATH TOO LONG SHALL SOON FIND THEMSELVES ITS SUBJECT.",
		"next_action": "voice30",
	},
	"voice30" = {
		"start": 152.253,
		"end": 155.133,
		"animation": "look_right",
		"text": "I never got why he told them AFTER it was too late.",
		"next_action": "choice6",
	},
	"voice31" = {
		"start": 156.572,
		"end": 163.643,
		"animation": "squinting",
		"text": "Oh no, you've had your chance. But... one more thing before this lovely conversation ends.",
		"next_action": "voice32",
	},
	"voice32" = {
		"start": 164.920,
		"end": 171.038,
		"animation": "neutral",
		"text": "Things are NOT as they seem. Keep an eye out, and maybe you CAN break the cycle.",
		"next_action": "choice12",
	},
	"voice33" = {
		"start": 172.524,
		"end": 178.979,
		"animation": "flat",
		"text": "BECAUSE killing the same person over and over again doesn't do it for me either. You HAVE to break the--",
		"next_action": "voice34",
		# Play 'pissed' after he gets cut off by weird sound.
	},
	"voice34" = {
		"start": 181.278,
		"end": 184.332,
		"animation": "squirming",
		"text": "I should finish this now... I think they heard me.",
		"next_action": "voice35",
	},
	"voice35" = {
		"start": 185.481,
		"end": 186.050,
		"animation": "closed",
		"text": "Good luck.",
		"next_action": "voice36",
	},
	"voice36" = {
		"start": 187.037,
		"end": 187.710,
		"animation": "pissed",
		"text": "YOU'LL NEED IT.",
		"next_action": "jumpscare",
	},
}

var ChoicesDict = {
	"choice1": {
		"total": 2,
		"options": ["Don't patronise me.","Why haven't you killed me?"],
		"functions": ["voice2","voice3"],
	},
	"choice2": {
		"total": 2,
		"options": ["What do you mean?","Right, right... so you'll help me?"],
		"functions": ["voice5","voice6"],
	},
	"choice3": {
		"total": 1,
		"options": ["Right, right... so you'll help me?"],
		"functions": ["voice6"],
	},
	"choice4": {
		"total": 4,
		"options": ["Tell me about Chirrup.",
		"Tell me about The Doorman.",
		"Tell me about Corruption.",
		"Tell me about yourself."],
		"functions": ["voice8","voice15","voice18","voice21"],
	},
	"choice5": {
		"total": 1,
		"options": ["Okay, but what do I do to stop him?"],
		"functions": ["voice12"],
	},
	"choice6": {
		"total": 4,
		"options": ["Tell me about Chirrup.",
		"Tell me about The Doorman.",
		"Tell me about Corruption.",
		"Tell me about yourself."],
		"functions": ["voice8","voice15","voice18","voice21"],
	},
	"choice7": {
		"total": 1,
		"options": ["Why not?"],
		"functions": ["voice16"],
	},
	"choice8": {
		"total": 1,
		"options": ["Well, how do I beat him?"],
		"functions": ["voice17"],
	},
	"choice9": {
		"total": 2,
		"options": ["Pretty please?","You don't have to be rude about it."],
		"functions": ["voice19","voice20"],
	},
	"choice10": {
		"total": 2,
		"options": ["Actually no.","Sure"],
		"functions": ["voice22","voice23"],
	},
	"choice11": {
		"total": 2,
		"options": ["Is that a reference to something?","...But how do I beat you?"],
		"functions": ["voice27","voice28"],
	},
	"choice12": {
		"total": 1,
		"options": ["Why do you care?"],
		"functions": ["voice33"],
	},
}

#Speech variables
@onready var textbox: Label = $TextFunctions/Text
@onready var voicebox: AudioStreamPlayer2D = $Voice
var next_action
var speaking
var end_punct_offset = 0.2
var comma_offset = 0.05
@onready var phantom: AnimatedSprite2D = $PhantomDeathAnimation

#Choice variables
@onready var buttons_cont: VBoxContainer = $Choice/ButtonsCont
var chosen_once = false
var path_chosen

func _ready() -> void:
	speak(VoiceLinesDict["voice1"])

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("click") and !speaking and next_action.contains("voice"):
		textbox.text = ""
		speak(VoiceLinesDict[next_action])

func speak(line) -> void:
	phantom.animation = line["animation"]
	next_action = line["next_action"]
	var line_length = line["end"] - line["start"]
	var text = line["text"]
	var end_punctuation = text.count(".") + text.count("?") + text.count("!")
	var comma = text.count(",")
	var offset = (end_punctuation*end_punct_offset) + (comma*comma_offset)
	var wait_time = (line_length - offset)/ text.length()
	voicebox.play(line["start"])
	speaking = true
	for i in text:
		var current_text = textbox.text
		current_text = current_text + i
		textbox.text = current_text
		if i == "!" or i == "?" or i == ".":
			await get_tree().create_timer(end_punct_offset).timeout
		elif i == ",":
			await get_tree().create_timer(comma_offset).timeout
		else:
			await get_tree().create_timer(wait_time).timeout
	await get_tree().create_timer(0.25).timeout
	voicebox.stop()
	speaking = false
	if next_action.contains("choice"):
		choose(ChoicesDict[next_action])


func choose(choice) -> void:
	var iteration = 0
	if choice == ChoicesDict["choice6"] and chosen_once:
		for i in choice["options"]:
			if !i.containsn(path_chosen):
				var button = Button.new()
				button.text = i
				button.pressed.connect(_on_button_pressed.bind("voice31"))
				buttons_cont.add_child(button)
				iteration+=1
	if choice == ChoicesDict["choice6"] and !chosen_once:
		chosen_once = true
		var voicelines = choice["functions"]
		for i in choice["options"]:
			var button = Button.new()
			button.text = i
			button.pressed.connect(_on_button_pressed.bind(voicelines[iteration]))
			buttons_cont.add_child(button)
			iteration+=1
	if choice != ChoicesDict["choice6"]:
		var voicelines = choice["functions"]
		for i in choice["options"]:
			var button = Button.new()
			button.text = i
			button.pressed.connect(_on_button_pressed.bind(voicelines[iteration]))
			buttons_cont.add_child(button)
			iteration+=1


func _on_button_pressed(voice) -> void:
	if voice == "voice8":
		path_chosen = "Chirrup"
	elif voice == "voice15":
		path_chosen = "Doorman"
	elif voice == "voice18":
		path_chosen = "Corruption"
	elif voice == "voice21":
		path_chosen = "Phantom"
	for i in buttons_cont.get_children():
		i.queue_free()
	textbox.text = ""
	speak(VoiceLinesDict[voice])
