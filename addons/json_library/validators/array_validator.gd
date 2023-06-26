class_name JArrayValidator extends JPropertyValidator

var _element_validator: JPropertyValidator

var _has_min_size := false
var _min_size := 0
var _has_max_size := false
var _max_size := 0


## Set the validator for the array elements
func elements(element_validator: JPropertyValidator) -> JArrayValidator:
	_element_validator = element_validator
	return self

## Set the minimum number of elements
func min_size(value: int) -> JArrayValidator:
	_has_min_size = true
	_min_size = value
	return self

## Set the maximum number of elements
func max_size(value: int) -> JArrayValidator:
	_has_max_size = true
	_max_size = value
	return self


func is_valid(data) -> bool:
	if data == null: return _is_nullable
	if not super.is_valid(data): return false
	else: return (
		data is Array
		and (data.size() >= _min_size if _has_min_size else true)
		and (data.size() <= _max_size if _has_max_size else true)
		and (data.all(_element_validator.is_valid) if _element_validator else true)
	)


func cleaned_data(data, _default = []) -> Array:
	return data.map(_element_validator.cleaned_data)


static func from_schema(schema: Dictionary) -> JPropertyValidator:
	if schema.get("type") == "array":
		var validator := JArrayValidator.new()
		if "minItems" in schema: validator.min_size(int(schema["minItems"]))
		if "maxItems" in schema: validator.max_size(int(schema["maxItems"]))
		if "items" in schema: validator.elements(JPropertyValidator.from_schema(schema["items"]))
		if "enum" in schema: validator.options(schema["enum"])
		return validator
	return null
