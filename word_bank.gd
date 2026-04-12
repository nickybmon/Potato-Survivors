extends Node

const _EASY: Array[String] = [
	"if", "as", "go", "do", "at", "be", "by", "up", "so", "or",
	"an", "in", "is", "it", "sad", "ask", "gas", "lag", "all", "fall",
	"flag", "glad", "slab", "flask", "fast", "last", "half", "dash",
	"lash", "also", "disk", "silk", "fill", "kill", "will", "hill",
	"bill", "still", "skill", "spill", "drill", "grill", "flat", "clan",
	"fist", "gust", "just", "dust", "rust", "gust", "list", "mist",
	"fist", "risk", "disk", "link", "sink", "wink", "pink", "rink"
]

const _MEDIUM: Array[String] = [
	"flash", "green", "drive", "fight", "sharp", "brave", "clock",
	"flame", "grind", "light", "plank", "trace", "field", "blaze",
	"storm", "black", "draft", "frost", "blend", "crisp", "sting",
	"swing", "track", "stand", "brand", "clamp", "glare", "flint",
	"press", "twist", "block", "clash", "craft", "drift", "flare",
	"grasp", "score", "spark", "strip", "trick", "troop", "slant",
	"grant", "plant", "slick", "brick", "prick", "trick", "click",
	"flick", "thick", "stack", "crack", "slack", "snack", "smack"
]

const _HARD: Array[String] = [
	"strength", "friction", "practice", "absolute", "constant",
	"fragment", "complete", "darkness", "keyboard", "quickfire",
	"challenge", "skillful", "threshold", "broadcast", "clockwork",
	"crossfire", "dispatch", "standard", "platform", "feedback",
	"crescent", "blackout", "contract", "daybreak", "district",
	"frontline", "hardback", "landscape", "mainframe", "nightfall",
	"outbreak", "overcast", "quicksand", "shortfall", "snapshot",
	"standout", "stopwatch", "tailwind", "tripwire", "undercut",
	"upstroke", "vantage", "wildcard", "windfall", "workspace"
]

var _pools: Array = [[], [], []]


func _ready() -> void:
	for i in 3:
		_refill(i)


func get_word(difficulty: int = 0) -> String:
	var d: int = clampi(difficulty, 0, 2)
	if _pools[d].is_empty():
		_refill(d)
	return _pools[d].pop_back()


func _refill(d: int) -> void:
	var source: Array[String]
	match d:
		0: source = _EASY
		1: source = _MEDIUM
		_: source = _HARD
	_pools[d] = source.duplicate()
	_pools[d].shuffle()
