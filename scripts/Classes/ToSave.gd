class_name ToSave

var high_score : int = 0

func set_high_score(score : int):
	high_score = score

func save():
	var save_dict = {
		"high_score" : 0
	}
	return save_dict
