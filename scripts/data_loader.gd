extends Node

var all_items: Array = []

func load_items() -> void:
	var file = FileAccess.open("res://items.json", FileAccess.READ)
	if file == null:
		push_error("Не удалось открыть items.json")
		return
	var json_text = file.get_as_text()
	file.close()
	var data = JSON.parse_string(json_text)
	if data is Array:
		all_items = data
		print("Успешно загружено предметов: ", all_items.size())
	else:
		push_error("JSON не является массивом")


func to_icon_path(display_name: String) -> String:
	var file_name = display_name.to_lower()
	file_name = file_name.replace(" ", "_")
	file_name = file_name.replace("-", "_")
	file_name = file_name.replace(",", "")
	return "res://assets/items/" + file_name + ".png"
