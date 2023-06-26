class_name JArrayValidator extends JPropertyValidator

var element_validator: JPropertyValidator

var unique_elements: bool = false
var has_min_size := false
var min_size := 0
var has_max_size := false
var max_size := 0


## Set the validator for the array elements
func set_element_validator(value: JPropertyValidator) -> JArrayValidator:
	element_validator = value
	return self


## Sets the validator to check that all elements in array are unique
func set_unique_elements(value: bool = true) -> JArrayValidator:
	unique_elements = value
	return self


## Set the minimum number of elements
func set_min_size(value: int) -> JArrayValidator:
	has_min_size = true
	min_size = value
	return self


## Set the maximum number of elements
func set_max_size(value: int) -> JArrayValidator:
	has_max_size = true
	max_size = value
	return self


func is_valid(data) -> bool:
	if data == null: return is_nullable
	if not super.is_valid(data): return false
	else: return (
		data is Array
		and (data.size() >= min_size if has_min_size else true)
		and (data.size() <= max_size if has_max_size else true)
		and (data.all(element_validator.is_valid) if element_validator else true)
		and (Json.List.all_elements_unique(data) if unique_elements else true)
	)


func cleaned_data(data, _default = []) -> Array:
	return data.map(element_validator.cleaned_data)


static func from_schema(schema: Dictionary) -> JPropertyValidator:
	if schema.get("type") == "array":
		var validator := JArrayValidator.new()
		if "minItems" in schema: validator.set_min_size(int(schema["minItems"]))
		if "maxItems" in schema: validator.set_max_size(int(schema["maxItems"]))
		if "items" in schema: validator.set_element_validator(JPropertyValidator.from_schema(schema["items"]))
		if "enum" in schema: validator.set_options(schema["enum"])
		if "uniqueItems" in schema: validator.set_unique_elements(schema["uniqueItems"])
		return validator
	return null
