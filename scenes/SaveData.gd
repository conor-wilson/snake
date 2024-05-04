class_name SaveData extends Resource

@export var high_score : int

const PATH : String = "user://snake_high_score.tres" 

func save_new_high_score(score:int):
	high_score = score
	ResourceSaver.save(self, PATH)

static func load() -> SaveData:
	
	if FileAccess.file_exists(PATH):
		return load(PATH) as SaveData
	else:
		return SaveData.new()
