class_name JStringValidator extends JPropertyValidator

## Handles validation and cleanup of [String] values
##
## See [JPathValidator] for a file-system specific subclass.


## If [code]true[/code], the validator will take [member min_length] into account during [method is_valid]
var has_min_length: bool = false
## If [member has_min_length] is [code]true[/code], the validator will check during [method is_valid] that the provided [String] is at least this many characters (inclusive)
var min_length: int = 0

## If [code]true[/code], the validator will take [member max_length] into account during [method is_valid]
var has_max_length: bool = false
## If [member has_min_length] is [code]true[/code], the validator will check during [method is_valid] that the provided [String] is at most this many characters (inclusive)
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


## Returns [code]true[/code] if the provided [code]data[/code] is a valid [String] based on the properties of this [JStringValidator] object.
## [br][b]Example:[/b]
## [codeblock]
## assert(JStringValidator.new()
##     .set_min_length(6)
##     .set_max_length(12)
##     .is_valid("password"))
## [/codeblock]
func is_valid(data) -> bool:
	if data == null: return is_nullable
	if not super.is_valid(data): return false
	return (
		data is String
		and (data.length() >= min_length if has_min_length else true)
		and (data.length() <= max_length if has_max_length else true)
	)


## Returns a new [JStringValidator] from the provided JSON schema [Dictionary].
## See the [url=https://json-schema.org/understanding-json-schema/reference/string.html]string JSON Schema documentation[/url] for more information
## about what type of input can be provided to the [code]schema[/code] parameter.
## [br][br][b]Note:[/b] Only the following string JSON Schema features are implemented (see [method JPropertyValidator.from_schema] for JSON schema features that apply to all data types)
## [br]• [url=https://json-schema.org/understanding-json-schema/reference/string.html#length][code]minLength[/code][/url] → [member min_length]
## [br]• [url=https://json-schema.org/understanding-json-schema/reference/string.html#length][code]maxLength[/code][/url] → [member max_length]
static func from_schema(schema: Dictionary) -> JPropertyValidator:
	if schema.get("type") == "string": 
		var validator := JStringValidator.new()
		if "minLength" in schema: validator.set_min_length(int(schema["minLength"]))
		if "maxLength" in schema: validator.set_max_length(int(schema["maxLength"]))
		if "enum" in schema: validator.set_options(schema["enum"])
		return validator
	return null
