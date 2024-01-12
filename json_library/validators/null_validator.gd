class_name JNullValidator extends JPropertyValidator

## Handles validation of [code]null[/code] values

## Returns [code]true[/code] if [code]data[/code] is [code]null[/code]
func is_valid(data) -> bool:
	return data == null


## Returns a new [JNullValidator] from a provided JSON schema [Dictionary].
## See the [url=https://json-schema.org/understanding-json-schema/reference/null.html]null JSON Schema documentation[/url] for more information
## about what type of input can be provided to the [code]schema[/code] parameter.
## [br][br]See [method JPropertyValidator.from_schema] for JSON schema features that apply to all data types.
static func from_schema(schema: Dictionary) -> JPropertyValidator:
	if schema.get("type") == "null": return JNullValidator.new()
	return null
