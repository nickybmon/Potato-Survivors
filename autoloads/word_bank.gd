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
	"affected", "aircraft", "alliance", "allocate", "altitude",
	"ambition", "analysis", "ancestry", "anterior", "antidote",
	"aperture", "armament", "artifact", "assassin", "assembly",
	"asterisk", "backtrack", "balanced", "barricade", "baseline",
	"battalion", "blacksmith", "blueprint", "bodyguard", "bombard",
	"boundary", "breakaway", "briefcase", "bulwark", "calculate",
	"callsign", "campaign", "capacity", "cardinal", "cartridge",
	"cascading", "catalyst", "cathedral", "cavalier", "celestial",
	"champion", "character", "checkpoint", "chemical", "chronicle",
	"circuitry", "civilian", "clearance", "clockwise", "coalition",
	"collapse", "commander", "commodity", "compress", "concrete",
	"conflict", "conquest", "construct", "contrast", "controls",
	"converge", "critical", "crossbow", "crusader", "currency",
	"cylinder", "database", "deadlock", "decisive", "decrypt",
	"defender", "deflect", "demolish", "deployed", "describe",
	"detonate", "diplomat", "displace", "distance", "doctrine",
	"document", "download", "dreadful", "dropship", "dynamic",
	"effective", "efficient", "elevation", "eliminate", "emergency",
	"encrypted", "endurance", "engineer", "enormous", "entrance",
	"epidemic", "escalate", "estimate", "evaluate", "evidence",
	"exchange", "exhaust", "explicit", "exposure", "external"
]

const _COMMON: Array[String] = [
	"the", "be", "to", "of", "and", "a", "in", "that", "have", "it",
	"for", "not", "on", "with", "he", "as", "you", "do", "at", "this",
	"but", "his", "by", "from", "they", "we", "say", "her", "she", "or",
	"an", "will", "my", "one", "all", "would", "there", "their", "what",
	"so", "up", "out", "if", "about", "who", "get", "which", "go", "me",
	"when", "make", "can", "like", "time", "no", "just", "him", "know",
	"take", "people", "into", "year", "your", "good", "some", "could",
	"them", "see", "other", "than", "then", "now", "look", "only", "come",
	"its", "over", "think", "also", "back", "after", "use", "two", "how",
	"our", "work", "first", "well", "way", "even", "new", "want", "because",
	"any", "these", "give", "day", "most", "us", "great", "between", "need",
	"large", "often", "hand", "high", "place", "hold", "turn", "move",
	"live", "where", "much", "through", "long", "down", "every", "door",
	"life", "real", "few", "north", "open", "seem", "together", "next",
	"white", "children", "begin", "got", "walk", "example", "ease", "paper",
	"group", "always", "music", "those", "both", "mark", "book", "letter",
	"until", "mile", "river", "car", "feet", "care", "second", "enough",
	"plain", "girl", "usual", "young", "ready", "above", "ever", "red",
	"list", "though", "feel", "talk", "bird", "soon", "body", "dog", "family",
	"direct", "pose", "leave", "song", "measure", "door", "product", "black",
	"short", "numeral", "class", "wind", "question", "happen", "complete",
	"ship", "area", "half", "rock", "order", "fire", "south", "problem",
	"piece", "told", "knew", "pass", "since", "top", "whole", "king",
	"space", "heard", "best", "hour", "better", "during", "hundred"
]

const _EXPANDED: Array[String] = [
	"ability", "absence", "absolute", "abstract", "accept", "access",
	"account", "achieve", "acquire", "action", "active", "adapt",
	"address", "advance", "affect", "agency", "agenda", "agent",
	"agree", "alarm", "align", "allow", "already", "although",
	"amount", "ancient", "animal", "annual", "answer", "appeal",
	"appear", "apply", "approach", "approve", "archive", "argue",
	"arrange", "arrest", "arrive", "aspect", "assign", "assist",
	"assume", "attach", "attack", "attempt", "attend", "attract",
	"author", "avoid", "balance", "barrier", "battle", "beauty",
	"become", "before", "behind", "believe", "benefit", "between",
	"beyond", "border", "bottle", "branch", "bridge", "broken",
	"budget", "bundle", "burden", "button", "camera", "cancel",
	"center", "certain", "change", "charge", "choose", "chosen",
	"circle", "citizen", "closely", "collect", "column", "combat",
	"coming", "comment", "common", "compare", "concept", "concern",
	"connect", "content", "control", "convert", "corner", "create",
	"culture", "danger", "damage", "decide", "defend", "define",
	"delete", "deliver", "design", "detail", "detect", "develop",
	"differ", "direct", "disable", "discuss", "domain", "double",
	"easily", "effect", "effort", "either", "enable", "energy",
	"engine", "entire", "entity", "entry", "equal", "escape",
	"evolve", "except", "expect", "explain", "export", "extend",
	"factor", "failure", "famous", "filter", "finish", "follow",
	"format", "former", "found", "future", "gather", "global",
	"govern", "happen", "handle", "health", "hidden", "higher",
	"history", "honest", "impact", "improve", "include", "increase",
	"indeed", "index", "insert", "inside", "install", "intent",
	"invite", "involve", "island", "itself", "launch", "leader",
	"learn", "lesson", "likely", "listen", "little", "local",
	"locate", "longer", "manage", "master", "matter", "member",
	"memory", "method", "middle", "mirror", "mission", "mobile",
	"moment", "monitor", "motion", "native", "nature", "nearly",
	"notice", "object", "obtain", "offset", "online", "option",
	"output", "outside", "packet", "parent", "pattern", "people",
	"period", "phrase", "pickup", "policy", "portal", "prefer",
	"pretty", "prevent", "primary", "private", "process", "provide",
	"public", "purpose", "quality", "random", "reason", "recent",
	"record", "reduce", "refer", "region", "release", "remain",
	"remove", "render", "repair", "repeat", "replace", "report",
	"request", "require", "resolve", "result", "return", "reveal",
	"review", "rotate", "router", "sample", "screen", "search",
	"secure", "select", "series", "server", "signal", "simple",
	"single", "source", "stable", "status", "string", "strong",
	"submit", "switch", "system", "target", "thread", "title",
	"toward", "travel", "trigger", "unable", "under", "update",
	"upload", "useful", "verify", "version", "virtual", "visible",
	"window", "within", "without", "working", "writer", "zero"
]

const _TECHNICAL: Array[String] = [
	"function", "const", "interface", "extends", "return", "import",
	"export", "default", "async", "await", "class", "static", "void",
	"public", "private", "protected", "abstract", "override", "final",
	"boolean", "integer", "string", "float", "double", "array",
	"object", "null", "undefined", "typeof", "instanceof", "new",
	"delete", "throw", "catch", "finally", "switch", "case", "break",
	"continue", "while", "for", "foreach", "lambda", "closure",
	"callback", "promise", "resolve", "reject", "module", "package",
	"namespace", "struct", "enum", "union", "pointer", "reference",
	"dereference", "malloc", "realloc", "buffer", "stack", "queue",
	"linked", "binary", "algorithm", "complexity", "recursion",
	"iteration", "dynamic", "runtime", "compile", "debugger",
	"breakpoint", "variable", "parameter", "argument", "scope",
	"context", "prototype", "inherit", "polymorphism", "encapsulate",
	"refactor", "deploy", "pipeline", "container", "docker", "kernel",
	"thread", "mutex", "semaphore", "deadlock", "memory", "cache",
	"latency", "throughput", "bandwidth", "protocol", "socket",
	"endpoint", "payload", "serialize", "deserialize", "encrypt",
	"decrypt", "hash", "token", "session", "cookie", "header",
	"request", "response", "middleware", "framework", "library",
	"dependency", "version", "branch", "commit", "merge", "rebase",
	"repository", "remote", "origin", "upstream", "checkout"
]

const _QUOTES: Array[String] = [
	"the quick brown fox jumps over the lazy dog",
	"to be or not to be that is the question",
	"in the beginning was the word",
	"all that glitters is not gold",
	"it was the best of times it was the worst of times",
	"ask not what your country can do for you",
	"the only thing we have to fear is fear itself",
	"we shall fight on the beaches",
	"one small step for man one giant leap for mankind",
	"I have a dream that one day this nation will rise up",
	"the truth will set you free but first it will make you miserable",
	"be the change you wish to see in the world",
	"two roads diverged in a wood and I took the one less traveled",
	"the greatest glory in living lies not in never falling but in rising every time we fall",
	"in three words I can sum up everything I have learned about life it goes on",
	"life is what happens to you while you are busy making other plans",
	"the way to get started is to quit talking and begin doing",
	"if life were predictable it would cease to be life and be without flavor",
	"if you look at what you have in life you will always have more",
	"do not go where the path may lead go instead where there is no path",
	"you will face many defeats in life but never let yourself be defeated",
	"the most difficult thing is the decision to act the rest is merely tenacity",
	"it is during our darkest moments that we must focus to see the light",
	"spread love everywhere you go let no one ever come to you without leaving happier",
	"when you reach the end of your rope tie a knot in it and hang on",
	"always remember that you are absolutely unique just like everyone else",
	"do not judge each day by the harvest you reap but by the seeds that you plant",
	"the future belongs to those who believe in the beauty of their dreams",
	"tell me and I forget teach me and I remember involve me and I learn",
	"the best time to plant a tree was twenty years ago the second best time is now",
	"an unexamined life is not worth living",
	"spread your wings and let the fairy in you fly",
	"I alone cannot change the world but I can cast a stone across the water to create many ripples",
	"not everything that is faced can be changed but nothing can be changed until it is faced",
	"it always seems impossible until it is done",
	"do what you can with all you have wherever you are",
	"if opportunity does not knock build a door",
	"I find that the harder I work the more luck I seem to have",
	"success is not final failure is not fatal it is the courage to continue that counts",
	"strive not to be a success but rather to be of value",
	"two things are infinite the universe and human stupidity and I am not sure about the universe",
	"you only live once but if you do it right once is enough",
	"in the middle of difficulty lies opportunity",
	"life is not measured by the number of breaths we take",
	"the secret of getting ahead is getting started",
	"your time is limited so do not waste it living someone else's life",
	"the only way to do great work is to love what you do",
	"innovation distinguishes between a leader and a follower",
	"stay hungry stay foolish",
	"we are all apprentices in a craft where no one ever becomes a master"
]

var _pool_easy: Array[String] = []
var _pool_medium: Array[String] = []
var _pool_hard: Array[String] = []
var _pool_common: Array[String] = []
var _pool_expanded: Array[String] = []
var _pool_technical: Array[String] = []
var _pool_quotes: Array[String] = []


func _ready() -> void:
	_refill_all()


func _refill_all() -> void:
	for i: int in 3:
		_refill(i)
	_refill_named("common")
	_refill_named("expanded")
	_refill_named("technical")
	_refill_named("quotes")


func get_word(difficulty: int = 0) -> String:
	var word: String = _draw_from_bank(GameConfig.word_bank, difficulty)
	word = _apply_modifiers(word)
	return word


# Returns a word whose first letter (post-modifiers) is not in blocked_letters.
# Tries up to 26 times then falls back to any word to avoid an infinite loop.
func get_word_avoiding(difficulty: int, blocked_letters: Array[String]) -> String:
	if blocked_letters.is_empty():
		return get_word(difficulty)
	for _attempt: int in 26:
		var candidate: String = _draw_from_bank(GameConfig.word_bank, difficulty)
		candidate = _apply_modifiers(candidate)
		if candidate.is_empty():
			return candidate
		var first := candidate[0].to_lower()
		if first not in blocked_letters:
			return candidate
	# Fallback — no safe word found, return anything
	return get_word(difficulty)


func get_quote() -> String:
	if _pool_quotes.is_empty():
		_refill_named("quotes")
	return _pool_quotes.pop_back()


func get_quote_capped(max_words: int) -> String:
	var full := get_quote()
	var words: Array = full.split(" ")
	if words.size() <= max_words:
		return full
	# Trim to max_words and return a clean phrase
	var trimmed: Array = words.slice(0, max_words)
	return " ".join(trimmed)


func _draw_from_bank(bank: String, difficulty: int) -> String:
	match bank:
		"easy":
			if _pool_easy.is_empty(): _refill(0)
			return _pool_easy.pop_back()
		"common":
			if _pool_common.is_empty():
				_refill_named("common")
			return _pool_common.pop_back()
		"expanded":
			if _pool_expanded.is_empty():
				_refill_named("expanded")
			return _pool_expanded.pop_back()
		"technical":
			if _pool_technical.is_empty():
				_refill_named("technical")
			return _pool_technical.pop_back()
		"quotes":
			return get_quote()
		_:
			return _draw_legacy(difficulty)


func _draw_legacy(difficulty: int) -> String:
	match clampi(difficulty, 0, 2):
		0:
			if _pool_easy.is_empty(): _refill(0)
			return _pool_easy.pop_back()
		1:
			if _pool_medium.is_empty(): _refill(1)
			return _pool_medium.pop_back()
		_:
			if _pool_hard.is_empty(): _refill(2)
			return _pool_hard.pop_back()
	return ""


func _apply_modifiers(word: String) -> String:
	# Capitalization: first letter only, not random internal letters
	if GameConfig.use_capitalization and not word.is_empty():
		word = word.substr(0, 1).to_upper() + word.substr(1)
	# Punctuation is not applied to individual survival words —
	# it belongs in sentence/quote context where grammar is meaningful.
	return word


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


func _refill_named(bank: String) -> void:
	match bank:
		"common":
			_pool_common = _COMMON.duplicate()
			_pool_common.shuffle()
		"expanded":
			_pool_expanded = _EXPANDED.duplicate()
			_pool_expanded.shuffle()
		"technical":
			_pool_technical = _TECHNICAL.duplicate()
			_pool_technical.shuffle()
		"quotes":
			_pool_quotes = _QUOTES.duplicate()
			_pool_quotes.shuffle()
