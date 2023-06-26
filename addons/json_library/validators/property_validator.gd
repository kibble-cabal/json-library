class_name JPropertyValidator extends Object

var is_optional: bool = false
var is_nullable: bool = false

var has_options: bool = false
var options: Array


func set_is_optional(value: bool = true) -> JPropertyValidator:
	is_optional = value
	return self


func set_is_nullable(value: bool = true) -> JPropertyValidator:
	is_nullable = value
	return self


func set_options(value: Array = []) -> JPropertyValidator:
	has_options = true
	options = value
	return self


## If [code]true[/code], the [code]data[/code] argument is valid
func is_valid(data) -> bool:
	if data == null: return is_nullable
	elif has_options: return data in options
	else: return true


func cleaned_data(data, default = null):
	return data if is_valid(data) else default


static func from_schema(schema: Dictionary) -> JPropertyValidator:
	match schema.get("type"): 
		"array": return JArrayValidator.from_schema(schema)
		"boolean": return JBoolValidator.from_schema(schema)
		"integer": return JIntValidator.from_schema(schema)
		"number": return JNumberValidator.from_schema(schema)
		"object": return JsonValidator.from_schema(schema)
		"string": return JStringValidator.from_schema(schema)
		_: return null
