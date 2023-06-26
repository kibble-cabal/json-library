class_name JStringValidator extends JPropertyValidator

var has_min_length: bool = false
var min_length: int = 0

var has_max_length: bool = false
var max_length: int = 0

## Sets the validator to check for a minimum number of characters (inclusive, so "abc" with a minimum length of 3 is valid)
func set_min_length(value: int) -> JStringValidator:
	min_length = value
	has_min_length = true
	return self


## Sets the validator to check for a maximum number of characters (inclusive, so "abc" with a maximum length of 3 is valid)
func set_max_length(value: int) -> JStringValidator:
	max_length = value
	has_max_length = true
	return self


func is_valid(data) -> bool:
	if data == null: return is_nullable
	if not super.is_valid(data): return false
	return (
		data is String
		and (data.length() >= min_length if has_min_length else true)
		and (data.length() <= max_length if has_max_length else true)
	)


static func from_schema(schema: Dictionary) -> JPropertyValidator:
	if schema.get("type") == "string": 
		var validator := JStringValidator.new()
		if "minLength" in schema: validator.set_min_length(int(schema["minLength"]))
		if "maxLength" in schema: validator.set_max_length(int(schema["maxLength"]))
		if "enum" in schema: validator.set_options(schema["enum"])
		return validator
	return null
