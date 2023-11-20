extends Node

var globalUsername = "Player0"

func _ready():
	# Generate and print a random name
	globalUsername = generateRandomName()

var medals = {
	"1": 0,
	"2": 0,
	"3": 0,
	"4": 0 
}

var stageMedalTimes = {
	"1" = {
		"bronze": 9,
		"silver": 8.2,
		"gold": 7.8,
		"author": 7.4 
	},
	"2" = {
		"bronze": 7.7,
		"silver": 6.9,
		"gold": 6.3,
		"author": 6.07 
	},
	"3" = {
		"bronze": 7.7,
		"silver": 7.2,
		"gold": 6.7,
		"author": 6.5 
	},
	"4" = {
		"bronze": 18,
		"silver": 16.6,
		"gold": 15,
		"author": 13.3
	}
}

func generateRandomName() -> String:
	var adjectives = ["Ancient", "Brave", "Cunning", "Daring", "Elegant", "Fierce", "Glorious", "Heroic", "Ingenious", "Jolly", "Kind", "Luminous", "Mighty", "Noble", "Optimistic", "Powerful", "Quick", "Radiant", "Strong", "Tough", "Unique", "Valiant", "Wise", "Xenial", "Youthful", "Zestful", "Adventurous", "Bright", "Creative", "Diligent"]
	var nouns = ["Warrior", "Dragon", "Castle", "Sword", "Forest", "King", "Queen", "Wizard", "Knight", "Eagle", "Phoenix", "Serpent", "Tiger", "Lion", "Bear", "Wolf", "Falcon", "Fox", "Hawk", "Panther", "Explorer", "Sailor", "Pirate", "Artist", "Scholar", "Rebel", "Champion", "Guardian", "Sage", "Mystic"]

	var adjective = adjectives[randi() % adjectives.size()]
	var noun = nouns[randi() % nouns.size()]
	return adjective + noun
