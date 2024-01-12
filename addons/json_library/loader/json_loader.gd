class_name JsonLoader extends Object

## Handles loading (and optionally validating) JSON files

## The path to load the JSON from
var path: String

## The [Dictionary] or [Object] to mutate with the loaded data
var output = {}

## The [Dictionary] that contains default data, in case of an issue during [method load]
var default_dict: Dictionary = {}

## The [JsonValidator] to use to validate data after [method load]. If [code]null[/code], validation
## will be skipped
var validator: JsonValidator = null

## If [code]true[/code], JSON keys will be converted to snake case during [method load]. This means
## that you don't need to worry about differing naming conventions in JSON vs GDscript files.
var config_keys_to_snake_case = false


func _init(path_value: String = "") -> void:
	path = path_value


## Set the [member output] to the provided [code]object[/code]. Can be a [Dictionary] or [Object].
func set_output(object) -> JsonLoader:
	output = object
	return self


## Set the [member default_dict] to be used during [method load]
func set_default_dict(default_value) -> JsonLoader:
	default_dict = default_value
	return self


## Set the [member validator] to be used during [method load]
func set_validator(validator_value: JsonValidator = null) -> JsonLoader:
	validator = validator_value
	return self


## When loading JSON, all KEYS will be recursively converted to snake case (values will be unaffected) (see [member config_keys_to_snake_case])
func to_snake_case(keys_to_snake_case_value := true) -> JsonLoader:
	config_keys_to_snake_case = keys_to_snake_case_value
	return self


func _convert_json_to_snake_case(dict: Dictionary) -> Dictionary:
	return JsonLibrary_Utils_Dict.map_keys(
		dict,
		func(key: String, _value): return key.to_snake_case(),
		true
	)


## 1. Parses the JSON from [code]string[/code].
## 2. If [member config_keys_to_snake_case] is [code]true[/code], converts data keys to snake case
## 3. If a [member validator] is provided, the loaded data will be validated and cleaned (see [method JsonValidator.is_valid] and [method JsonValidator.cleaned_data]).
## 4. [member output] will be mutated with the loaded data and returned. This means that you can load JSON that effects node properties and other cool things.
func load_from_string(string: String):
	var data := JSON.parse_string(string)
	
	var data_dict: Dictionary = data if data != null else default_dict
	
	# Convert to snake case, if necessary
	if config_keys_to_snake_case:
		data_dict = _convert_json_to_snake_case(data_dict)
	
	# Validate data
	var cleaned_data
	if validator:
		if data_dict and validator.is_valid(data): 
			cleaned_data = validator.cleaned_data(data, default_dict)
	else: cleaned_data = data_dict
	
	# Mutate output
	if cleaned_data is Dictionary:
		if output is Object:
			for key in cleaned_data:
				if key in output: output[key] = cleaned_data[key]
		elif output is Dictionary: output.merge(cleaned_data, true)
	else: output = cleaned_data
	
	return output


## 1. Loads the file at [member path].
## 2. If [member config_keys_to_snake_case] is [code]true[/code], converts data keys to snake case
## 3. If a [member validator] is provided, the loaded data will be validated and cleaned (see [method JsonValidator.is_valid] and [method JsonValidator.cleaned_data]).
## 4. [member output] will be mutated with the loaded data and returned. This means that you can load JSON that effects node properties and other cool things.
func load():
	if FileAccess.file_exists(path):
		# Read file
		var file := FileAccess.open(path, FileAccess.READ)
		var string := file.get_as_text()

		# Load JSON
		return load_from_string(string)
	
	return output
