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
		"start": 0.65,
		"end": 4.54,
		"animation": "neutral",
		"text": "Why haven't I killed you YET?",
		"next_action": "voice4",
	},
}
