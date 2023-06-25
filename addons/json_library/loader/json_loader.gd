class_name JsonLoader extends Object

var _path: String
var _output = {}
var _default_dict: Dictionary = {}
var _validator: JsonValidator = null

var _config := {
	keys_to_snake_case = false
}

func _init(path: String) -> void:
	_path = path


func output(object) -> JsonLoader:
	_output = object
	return self


func default_dict(default_value) -> JsonLoader:
	_default_dict = default_value
	return self


func validator(validator_value: JsonValidator = null) -> JsonLoader:
	_validator = validator_value
	return self


## When loading JSON, all KEYS will be recursively converted to snake case (values will be unaffected)
func to_snake_case(keys_to_snake_case_value := true) -> JsonLoader:
	_config.keys_to_snake_case = keys_to_snake_case_value
	return self


func _convert_json_to_snake_case(dict: Dictionary) -> Dictionary:
	return JsonLibrary_Utils_Dict.map_keys(
		dict,
		func(key: String, _value): return key.to_snake_case(),
		true
	)


func load():
	if FileAccess.file_exists(_path):
		# Read file
		var file := FileAccess.open(_path, FileAccess.READ)
		var string := file.get_as_text()
		var data := JSON.parse_string(string)
		
		var data_dict: Dictionary = data if data != null else _default_dict
		
		# Convert to snake case, if necessary
		if _config.keys_to_snake_case:
			data_dict = _convert_json_to_snake_case(data_dict)
		
		# Validate data
		var cleaned_data
		if _validator:
			if data_dict and _validator.is_valid(data): 
				cleaned_data = _validator.cleaned_data(data, _default_dict)
		else: cleaned_data = data_dict
		
		# Mutate output
		if cleaned_data is Dictionary:
			if _output is Object:
				for key in cleaned_data:
					if key in _output: _output[key] = cleaned_data[key]
			elif _output is Dictionary: _output.merge(cleaned_data, true)
		else: _output = cleaned_data
	
	return _output
