class_name JArrayValidator extends JPropertyValidator

## Handles validation and data cleanup of an [Array] value


## If [member element_validator] is not [code]null[/code], during [method is_valid] each element in the provided data will be validated with this validator
var element_validator: JPropertyValidator

## If [code]true[/code], the validator will check during [method is_valid] that all elements in the array are unique
var unique_elements: bool = false

## If [code]true[/code], the validator will take into account [member min_size] during [method is_valid]
var has_min_size := false

## If [member has_min_size] is [code]true[/code], the validator will check during [method is_valid] that there are at least this many elements in the provided data (inclusive)
var min_size := 0

## If [code]true[/code], the validator will take into account [member max_size] during [method is_valid]
var has_max_size := false

## If [member has_max_size] is [code]true[/code], the validator will check during [method is_valid] that there are at maximum this many elements in the provided data (inclusive)
var max_size := 0


## Set the validator for the array elements (see [member element_validator])
func set_element_validator(value: JPropertyValidator) -> JArrayValidator:
	element_validator = value
	return self


## Set the validator to check that all elements in array are unique (see [member unique_elements])
func set_unique_elements(value: bool = true) -> JArrayValidator:
	unique_elements = value
	return self


## Set the minimum number of elements (see [member min_size])
func set_min_size(value: int) -> JArrayValidator:
	has_min_size = true
	min_size = value
	return self


## Set the maximum number of elements (see [member max_size])
func set_max_size(value: int) -> JArrayValidator:
	has_max_size = true
	max_size = value
	return self


## Returns [code]true[/code] if [code]data[/code] is a valid [Array] based on the properties of this [JArrayValidator] object.
## [br][b]Example:[/b]
## [codeblock]
## assert(JArrayValidator.new()
##     .set_element_validator(JIntValidator.new())
##     .set_min_length(1)
##     .set_max_length(5)
##     .is_valid([1, 2, 3])
## [/codeblock]
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


## Returns the provided [code]data[/code] with each element cleaned by the [member element_validator], if it exists.
## If [code]data[/code] is not valid, returns [code]default[/code].
func cleaned_data(data, default = []) -> Array:
	if is_valid(data) and data is Array:
		if element_validator: return data.map(element_validator.cleaned_data)
		else: return data
	else: return default


## Returns a new [JArrayValidator] from a provided JSON schema [Dictionary].
## See the [url=https://json-schema.org/understanding-json-schema/reference/array.html]array JSON Schema documentation[/url] for more information
## about what type of input can be provided to the [code]schema[/code] parameter.
## [br][br][b]Note:[/b] Only the following Array JSON Schema features are implemented (see [method JPropertyValidator.from_schema] for JSON schema features that apply to all data types)
## [br]• [url=https://json-schema.org/understanding-json-schema/reference/array.html#length][code]minItems[/code][/url] → [member min_size]
## [br]• [url=https://json-schema.org/understanding-json-schema/reference/array.html#length][code]maxItems[/code][/url] → [member max_size]
## [br]• [url=https://json-schema.org/understanding-json-schema/reference/array.html#items][code]items[/code][/url] → [member element_validator]
## [br]• [url=https://json-schema.org/understanding-json-schema/reference/array.html#uniqueness][code]uniqueItems[/code][/url] → [member uniqueItems]
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
