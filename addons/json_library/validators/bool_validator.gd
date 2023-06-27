class_name JBoolValidator extends JPropertyValidator


## Handles validation and data cleanup of a [bool] value

## If [code]true[/code], the validator will accept truthy and falsy values (as well as regular [bool]s) in [method is_valid] and returned regular [bool]s in [method cleaned_data].
## [br][br]See [method is_truthy] and [method is_falsy].
var allow_truthy_falsy := false


## Set [member allow_truthy_falsy] to the provided value
func set_allow_truthy_falsy(value := true) -> JBoolValidator:
	allow_truthy_falsy = value
	return self


## Returns [code]true[/code] if a value is:
## [br]• [code]true[/code]
## [br]• Any variation on the word [code]"true"[/code] (e.g. [code]"True"[/code], [code]"TRUE"[/code])
## [br]• Any number greater than [code]0[/code]
## [br]• A non-empty [Array] or [Dictionary]
## [br]• A valid [Object]
static func is_truthy(value) -> bool:
	if value is bool and value == true: return true
	if value is String: return value.to_lower() == "true"
	if value is float or value is int: return value > 0
	if value is Array or value is Dictionary: return not value.is_empty()
	if value is Object: return is_instance_valid(value)
	return false


## Returns [code]true[/code] if a value is:
## [br]• [code]false[/code]
## [br]• Any variation on the word [code]"false"[/code] (e.g. [code]"False"[/code], [code]"FALSE"[/code])
## [br]• Any number greater than [code]0[/code]
## [br]• An empty [Array] or [Dictionary]
## [br]• An invalid [Object]
## [br]• [code]null[/code]
static func is_falsy(value) -> bool:
	if value is bool and value == false: return true
	if value is String: return value.to_lower() == "false"
	if value is float or value is int: return value <= 0
	if value is Array or value is Dictionary: return value.is_empty()
	if value is Object: return not is_instance_valid(value)
	if value == null: return true
	return false


## Returns [code]true[/code] if the given value is a valid [bool] based on the properties of this validator.
## [br][b]Examples:[/b]
## [codeblock]
## assert(JBoolValidator.new().is_valid(true))
## assert(JBoolValidator.new().set_allow_truthy_falsy(true).is_valid("true"))
## assert(JBoolValidator.new().is_valid(null) == false) # invalid
## [/codeblock]
func is_valid(data) -> bool:
	if data == null: return is_nullable
	if not super.is_valid(data): return false
	if data is bool: return true
	elif allow_truthy_falsy: return is_truthy(data) or is_falsy(data)
	else: return false


## If [code]data[/code] is valid, returns the provided [code]data[/code] in a cleaned format. This means converting truthy/falsy values to their corresponding [bool].
## Otherwise, returns the [code]default[/code] value.
func cleaned_data(data, default = false) -> bool:
	if not is_valid(data): return default
	return is_truthy(data)


## Returns a new [JBoolValidator] from the provided JSON schema [Dictionary].
## See the [url=https://json-schema.org/understanding-json-schema/reference/boolean.html]boolean JSON Schema documentation[/url] for more information
## about what type of input can be provided to the [code]schema[/code] parameter.
## [br][br]See [method JPropertyValidator.from_schema] for JSON schema features that apply to all data types.
static func from_schema(schema: Dictionary) -> JPropertyValidator:
	if schema.get("type") == "boolean": 
		var validator := JBoolValidator.new()
		if "enum" in schema: validator.set_options(schema["enum"])
		return validator
	return null
