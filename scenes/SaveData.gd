class_name SaveData extends Resource

@export var high_score : int

const PATH : String = "user://snake_high_score.tres" 

func save():
	ResourceSaver.save(self, PATH)

static func load_high_score() -> SaveData:
	
	if FileAccess.file_exists(PATH):
		return load(PATH) as SaveData
	else:
		return SaveData.new()
