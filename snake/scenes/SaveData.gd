class_name SaveData extends Resource

## The SaveData class encapsulates all of the player's save data for Snake, as well as
## functions for loading and controling it.
##
## NOTE: This is the only file within Snake that doesn't adhere to the snake_case
##       convention for filenames within Godot's style guide. The reason for this
##       exception is that changing this file to save_data.gd caused compiler errors
##       to occur within main.gd. This was investigated briefly but was ultimately
##       determined not worth the hassle to solve, as it's honestly a purely aesthetic
##       issue.

# PATH defines the path to the file to which the user's save data will be stored.
const PATH : String = "user://snake_save_data.tres" 

var high_score         : int  # The player's high-score
var worm_mode_unlocked : bool # If true, the player has unlocked WORM MODE

# load loads the player's current save data, booting a fresh SaveData variable if it no
# save file exists.
static func load() -> SaveData:
	if FileAccess.file_exists(PATH):
		return load(PATH) as SaveData
	else:
		return SaveData.new()


# save_new_high_score saves the player's high-score to be equal to the provided int. The
# function also unlocks WORM MODE if the new high score is higher than the global
# WORM MODE theshold.
func save_new_high_score(score:int):
	high_score = score
	worm_mode_unlocked = score >= Global.WORM_MODE_THRESHOLD
	ResourceSaver.save(self, PATH)
