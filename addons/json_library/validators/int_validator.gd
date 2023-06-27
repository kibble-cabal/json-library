class_name JIntValidator extends JNumberValidator


## Handles validation and cleanup of [int] data


## Returns [code]true[/code] if the provided [code]data[/code] is a valid [int] based on the properties of this [JIntValidator] object.
## [br][b]Example:[/b]
## [codeblock]
## assert(JIntValidator.new()
##     .set_minimum(0)
##     .set_maximum(10)
##     .is_valid(5))
## [/codeblock]
func is_valid(data) -> bool:
	if data == null: return is_nullable
	return super.is_valid(data) and Json.Math.is_rounded(data)


## If the provided [code]data[/code] is a valid [int], returns [code]data[/code]. Otherwise, returns [code]default[/code].
func cleaned_data(data, default = 0) -> int:
	if not is_valid(data): return default
	return (
		roundi(data) if data is float
		else data if data is int
		else default
	)


## Returns a new [JIntValidator] from the provided JSON schema [Dictionary].
## See the [url=https://json-schema.org/understanding-json-schema/reference/numeric.html#integer]integer JSON Schema documentation[/url] for more information
## about what type of input can be provided to the [code]schema[/code] parameter.
## [br][br][b]Note:[/b] 
## [br]• See [method JPropertyValidator.from_schema] for JSON schema features that apply to all data types
## [br]• See [method JNumberValidator.from_schema] for JSON schema features that apply to numeric data types
static func from_schema(schema: Dictionary) -> JPropertyValidator:
	if schema.get("type") == "integer":
		var validator := JIntValidator.new()
		if "minimum" in schema: validator.set_minimum(int(schema["minimum"]))
		if "exclusiveMinimum" in schema: validator.set_minimum_exclusive(int(schema["exclusiveMinimum"]))
		if "maximum" in schema: validator.set_maximum(int(schema["maximum"]))
		if "exclusiveMaximum" in schema: validator.set_maximum_exclusive(int(schema["exclusiveMaximum"]))
		if "multipleOf" in schema: validator.set_step(int(schema["multipleOf"]))
		if "enum" in schema: validator.set_options(schema["enum"])
		return validator
	return null
