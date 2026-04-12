extends Node

const _EASY: Array[String] = [
	"if", "as", "go", "do", "at", "be", "by", "up", "so", "or",
	"an", "in", "is", "it", "sad", "ask", "gas", "lag", "all", "fall",
	"flag", "glad", "slab", "flask", "fast", "last", "half", "dash",
	"lash", "also", "disk", "silk", "fill", "kill", "will", "hill",
	"bill", "still", "skill", "spill", "drill", "grill", "flat", "clan",
	"fist", "just", "dust", "rust", "list", "mist", "risk", "link",
	"sink", "wink", "pink", "rink"
]

const _MEDIUM: Array[String] = [
	"flash", "green", "drive", "fight", "sharp", "brave", "clock",
	"flame", "grind", "light", "plank", "trace", "field", "blaze",
	"storm", "black", "draft", "frost", "blend", "crisp", "sting",
	"swing", "track", "stand", "brand", "clamp", "glare", "flint",
	"press", "twist", "block", "clash", "craft", "drift", "flare",
	"grasp", "score", "spark", "strip", "trick", "troop", "slant",
	"grant", "plant", "slick", "brick", "click", "flick", "thick",
	"stack", "crack", "slack", "snack", "smack"
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
	"upstroke", "wildcard", "windfall", "workspace"
]

var _pool_easy: Array[String] = []
var _pool_medium: Array[String] = []
var _pool_hard: Array[String] = []


func _ready() -> void:
	_refill(0)
	_refill(1)
	_refill(2)


func get_word(difficulty: int = 0) -> String:
	match clampi(difficulty, 0, 2):
		0:
			if _pool_easy.is_empty():
				_refill(0)
			return _pool_easy.pop_back()
		1:
			if _pool_medium.is_empty():
				_refill(1)
			return _pool_medium.pop_back()
		_:
			if _pool_hard.is_empty():
				_refill(2)
			return _pool_hard.pop_back()
	return ""


func _refill(d: int) -> void:
	match d:
		0:
			_pool_easy = _EASY.duplicate()
			_pool_easy.shuffle()
		1:
			_pool_medium = _MEDIUM.duplicate()
			_pool_medium.shuffle()
		_:
			_pool_hard = _HARD.duplicate()
			_pool_hard.shuffle()
