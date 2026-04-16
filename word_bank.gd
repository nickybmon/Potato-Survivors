extends Node

const _EASY: Array[String] = [
	"if", "as", "go", "do", "at", "be", "by", "up", "so", "or",
	"an", "in", "is", "it", "sad", "ask", "gas", "lag", "all", "fall",
	"flag", "glad", "slab", "flask", "fast", "last", "half", "dash",
	"lash", "also", "disk", "silk", "fill", "kill", "will", "hill",
	"bill", "still", "skill", "spill", "drill", "grill", "flat", "clan",
	"fist", "just", "dust", "rust", "list", "mist", "risk", "link",
	"sink", "wink", "pink", "rink",
	"cat", "dog", "run", "hit", "red", "big", "old", "new", "top",
	"cut", "fun", "sun", "gun", "bun", "mud", "bug", "jug", "tug",
	"rug", "hub", "sub", "pub", "rub", "cub", "job", "mob", "rob",
	"bob", "pod", "rod", "cod", "fog", "log", "bog", "hog", "jog",
	"cog", "dot", "got", "hot", "lot", "not", "pot", "rot", "tot",
	"box", "fox", "lox", "mix", "fix", "six", "wax", "tax", "fax",
	"bad", "dad", "had", "lad", "mad", "rap", "cap", "gap", "lap",
	"map", "nap", "sap", "tap", "yap", "zap", "bar", "car", "far",
	"jar", "tar", "war", "bit", "fit", "hit", "kit", "lit", "pit",
	"sit", "wit", "ban", "can", "fan", "man", "pan", "ran", "tan",
	"van", "bed", "fed", "led", "red", "wed", "gel", "elf", "elk",
	"elm", "emu", "end", "era", "eve", "age", "ace", "ice", "ore"
]

const _MEDIUM: Array[String] = [
	"flash", "green", "drive", "fight", "sharp", "brave", "clock",
	"flame", "grind", "light", "plank", "trace", "field", "blaze",
	"storm", "black", "draft", "frost", "blend", "crisp", "sting",
	"swing", "track", "stand", "brand", "clamp", "glare", "flint",
	"press", "twist", "block", "clash", "craft", "drift", "flare",
	"grasp", "score", "spark", "strip", "trick", "troop", "slant",
	"grant", "plant", "slick", "brick", "click", "flick", "thick",
	"stack", "crack", "slack", "snack", "smack",
	"arrow", "blunt", "brisk", "brush", "burst", "catch", "chain",
	"chart", "chase", "check", "chest", "chill", "choke", "churn",
	"clank", "clear", "climb", "cling", "cloak", "cloud", "crush",
	"curve", "cycle", "depth", "digit", "dirge", "ditch", "dodge",
	"doubt", "drain", "drawl", "dread", "drawn", "drill", "droop",
	"drove", "drown", "dwarf", "eagle", "earth", "eight", "ember",
	"epoch", "equip", "evade", "event", "extra", "fable", "facet",
	"faith", "false", "fault", "feast", "fetch", "fever", "fiber",
	"final", "first", "fixed", "flame", "flank", "flare", "flask",
	"flock", "flood", "floor", "floss", "flour", "fluid", "fluke",
	"flunk", "focus", "force", "forge", "forth", "found", "frank",
	"fraud", "freak", "fresh", "front", "froth", "froze", "fruit",
	"fully", "fungi", "gavel", "ghost", "girth", "given", "gland",
	"glare", "glass", "globe", "gloom", "gloss", "glyph", "gnash",
	"grace", "grade", "grain", "graph", "grasp", "grave", "graze",
	"greed", "greet", "grief", "grill", "gripe", "groan", "groin",
	"grope", "gross", "group", "grout", "grove", "growl", "gruel",
	"guard", "guile", "guise", "gulch", "gully", "gusto", "haste",
	"haunt", "haven", "heavy", "hence", "hoard", "honor", "hover",
	"human", "humid", "humor", "hurry", "husky", "image", "imply",
	"inbox", "incur", "infer", "input", "intro", "irony", "ivory"
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
	"upstroke", "wildcard", "windfall", "workspace",
	"abstract", "accuracy", "activate", "actually", "addition",
	"adequate", "adjacent", "adjusted", "advanced", "adversary",
	"affected", "affirm", "aircraft", "alliance", "allocate",
	"altitude", "ambition", "amplify", "analysis", "ancestry",
	"annihilate", "anterior", "antidote", "aperture", "armament",
	"artifact", "assassin", "assembly", "asterisk", "backtrack",
	"balanced", "barricade", "baseline", "battalion", "bayonet",
	"blacksmith", "blueprint", "bodyguard", "boldness", "bombard",
	"boundary", "breakaway", "breastplate", "briefcase", "bulwark",
	"calculate", "callsign", "campaign", "capacity", "cardinal",
	"cartridge", "cascading", "catalyst", "cathedral", "cavalier",
	"celestial", "champion", "character", "checkpoint", "chemical",
	"chronicle", "circuitry", "civilian", "clandestine", "clearance",
	"clockwise", "coalition", "codebreak", "coldfront", "collapse",
	"commander", "commodity", "compress", "compute", "concrete",
	"conflict", "conquest", "constant", "construct", "continue",
	"contrast", "controls", "converge", "critical", "crossbow",
	"crusader", "currency", "cylinder", "database", "deadlock",
	"debris", "decisive", "decrypt", "defender", "deflect",
	"demolish", "deployed", "describe", "deserter", "detonate",
	"diplomat", "displace", "distance", "doctrine", "document",
	"download", "dreadful", "dropship", "dungeon", "dynamic",
	"effective", "efficient", "elevation", "eliminate", "emergency",
	"encrypted", "endurance", "engineer", "enormous", "entrance",
	"epidemic", "escalate", "estimate", "evaluate", "evidence",
	"exchange", "exhaust", "explicit", "exposure", "external",
	"extremity", "facility", "fallback", "fastbreak", "fieldwork",
	"firepower", "fireworks", "flagship", "flashback", "flatline",
	"fortified", "freefall", "frequency", "frontline", "fullscale",
	"function", "fuselage", "garrison", "gateway", "generate",
	"gladiator", "gradient", "gridlock", "gritty", "guardian",
	"gunsmith", "hardline", "hardware", "headcount", "headstart",
	"heartbeat", "heavyfire", "helmsman", "highgrade", "highlight",
	"holdfast", "homeland", "hostile", "humanity", "hurricane",
	"hyperlink", "identify", "ignition", "imminent", "immunity",
	"impacted", "imperial", "impulse", "incursion", "infantry",
	"infinite", "ingress", "initiate", "intercept", "internal"
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
