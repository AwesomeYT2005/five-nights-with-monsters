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
}
