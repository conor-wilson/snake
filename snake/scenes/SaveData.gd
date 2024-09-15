class_name SaveData extends Resource

@export var high_score : int
@export var worm_mode_unlocked : bool

const WORM_MODE_THRESHOLD : int = 50

const PATH : String = "user://snake_save_data.tres" 

func save_new_high_score(score:int):
	high_score = score
	worm_mode_unlocked = score >= WORM_MODE_THRESHOLD

	ResourceSaver.save(self, PATH)

static func load() -> SaveData:
	
	if FileAccess.file_exists(PATH):
		return load(PATH) as SaveData
	else:
		return SaveData.new()
