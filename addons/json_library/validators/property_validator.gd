class_name JPropertyValidator extends Object

## Base class for handling validation and cleanup of all JSON data types
##
## This is the base class for all other JSON validators. It doesn't do much validation on its own,
## but may be useful if you have want to validate a [Variant].
## [br][br]See the following subclasses:
## [br]• [JArrayValidator]
## [br]• [JBoolValidator]
## [br]• [JDictValidator]
## [br]• [JEnumValidator]
## [br]• [JFloatValidator]
## [br]• [JIntValidator]
## [br]• [JsonValidator]
## [br]• [JNullValidator]
## [br]• [JNumberValidator]
## [br]• [JPathValidator]
## [br]• [JStringValidator]
## [br]• [JVectorValidator]

## If [code]true[/code], this property is not required. Applicable when this validator is a property in a larger [member JsonValidator] (see [member JsonValidator.validators])
var is_optional: bool = false

## If [code]true[/code], [method is_valid] will always allow [code]null[/code] as a valid value
var is_nullable: bool = false

## If [code]true[/code], [method is_valid] will check that the provided data is one of [member options]
var has_options: bool = false

## If [member has_options] is [code]true[/code], [method is_valid] will check that the provided data is one of the values in [member options]
var options: Array

## Set [member is_optional] to the provided value
func set_is_optional(value: bool = true) -> JPropertyValidator:
	is_optional = value
	return self

## Set [member is_null] to the provided value
func set_is_nullable(value: bool = true) -> JPropertyValidator:
	is_nullable = value
	return self


## Set [member options] to the provided value
func set_options(value: Array = []) -> JPropertyValidator:
	has_options = true
	options = value
	return self


## If [code]true[/code], the [code]data[/code] argument is valid
func is_valid(data) -> bool:
	if data == null: return is_nullable
	elif has_options: return data in options
	else: return true


## If the data is valid, returns the provided [code]data[/code] as-is. Otherwise, returns the [code]default[/code].
func cleaned_data(data, default = null):
	return data if is_valid(data) else default


## Returns a new [JPropertyValidator] from a provided JSON schema [Dictionary].
## See the [url=https://json-schema.org/understanding-json-schema/reference/index.html]JSON Schema documentation[/url] for more information
## about what type of input can be provided to the [code]schema[/code] parameter.
## [br][br][b]Note:[/b] The following JSON Schema features are implemented for all JSON Schema types
## [br]• [url=https://json-schema.org/understanding-json-schema/reference/type.html][code]type[/code][/url] → decides what subclass of [JPropertyValidator] this function will return
## [br]• [url=https://json-schema.org/understanding-json-schema/reference/generic.html#enumerated-values][code]enum[/code][/url] → [member options]
static func from_schema(schema: Dictionary) -> JPropertyValidator:
	match schema.get("type"): 
		"array": return JArrayValidator.from_schema(schema)
		"boolean": return JBoolValidator.from_schema(schema)
		"integer": return JIntValidator.from_schema(schema)
		"number": return JNumberValidator.from_schema(schema)
		"object": return JsonValidator.from_schema(schema)
		"string": return JStringValidator.from_schema(schema)
		_: return null
