extends Node

const EASY: Array[String] = [
	"if", "as", "go", "do", "at",
	"be", "by", "up", "so", "or",
	"an", "in", "is", "it", "sad",
	"ask", "gas", "lag", "all", "fall",
	"flag", "glad", "slab", "flask", "adds"
]

const MEDIUM: Array[String] = [
	"flash", "green", "drive", "fight", "sharp",
	"brave", "clock", "flame", "grind", "light",
	"plank", "trace", "field", "blaze", "storm",
	"black", "draft", "frost", "blend", "crisp"
]

const HARD: Array[String] = [
	"strength", "friction", "practice", "absolute",
	"constant", "fragment", "complete", "darkness",
	"keyboard", "quickfire", "challenge", "skillful",
	"threshold", "broadcast", "clockwork", "crossfire"
]

func get_word(difficulty: int = 0) -> String:
	match difficulty:
		0: return EASY[randi() % EASY.size()]
		1: return MEDIUM[randi() % MEDIUM.size()]
		_: return HARD[randi() % HARD.size()]
