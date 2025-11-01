extends Node

const FILE_PATH :String= "user://save_data.ini"
var  config :ConfigFile= ConfigFile.new()
var rng := RandomNumberGenerator.new()
static var questions_arr = []
static var answer_arr = []
static var temp_questions_arr = []
static var temp_answer_arr = []
static var user_answer = {}
static var ImageAndLabel = {}
static var symbols: bool
static var typo : bool 
static var space : bool
static var auto: bool 
static var qrMaze:bool = false
static var linearMaze : bool = false
static var currency: int = 500

static var Angelboots : bool = false
static var Godeye : bool = false
static var Shield : bool = false
static var Seaside : bool = false
#boolean signifies that the item was already bought
static var skill1 : bool = false
static var skill2: bool = false
static var skill3 : bool = false
static var skill4: bool = false

static var demon:bool = false
static var angel: bool = false
static var thoughts: bool = false
static var complementary: bool = false
#boolean signifies that the item was already bought
static var access1 :bool = false
static var access2: bool = false
static var access3 :bool = false
static var access4 :bool = false

static var no_of_hints: int = 10

static var new : bool = true

func _ready() -> void:
	if !FileAccess.file_exists(FILE_PATH):
		set_values()
	else:
		config.load(FILE_PATH)
		get_values()
		
func set_values():
		#settings
		config.set_value("settings", "auto", auto)
		config.set_value("settings", "symbols", symbols)
		config.set_value("settings", "space", space)
		config.set_value("settings", "typo", typo)
		
		#currency
		config.set_value("currency", "total", currency)
		
		#bought items
		config.set_value("bought", "skill1", skill1)
		config.set_value("bought","skill2", skill2)
		config.set_value("bought", "skill3", skill3)
		config.set_value("bought","skill4", skill4)
		config.set_value("bought", "access1", access1)
		config.set_value("bought","access2", access2)
		config.set_value("bought", "access3", access3)
		config.set_value("bought","access4", access4)
		config.set_value("bought","hints", no_of_hints)
		
		#used_items
		config.set_value("used", "boots", Angelboots)
		config.set_value("used","eye", Godeye)
		config.set_value("used", "shield", Shield)
		config.set_value("used","vacation", Seaside)
		config.set_value("used", "demon", demon)
		config.set_value("used","angel", angel)
		config.set_value("used", "thoughts", thoughts)
		config.set_value("used","complementary", complementary)
		
		config.save(FILE_PATH)

func get_values():
	auto = config.get_value("settings", "auto")
	symbols = config.get_value("settings", "symbols")
	space = config.get_value("settings", "space")
	typo = config.get_value("settings", "typo")
	
	currency = config.get_value("currency", "total")
	
	skill1 = config.get_value("bought", "skill1")
	skill2 = config.get_value("bought","skill2")
	skill3 = config.get_value("bought", "skill3")
	skill4 = config.get_value("bought","skill4")
	access1 = config.get_value("bought", "access1")
	access2 = config.get_value("bought","access2")
	access3 = config.get_value("bought", "access3")
	access4 = config.get_value("bought","access4")
	no_of_hints = config.get_value("bought","hints")

func access_random_num_on_question(value_max:int) -> int:
	rng.randomize()
	var randomnum := rng.randi_range(0 , (value_max - 1))
	return randomnum
