class_name JPropertyValidator extends Object

## The name of the JSON property that this validator corresponds to
var key: String

var _is_optional: bool = false
var _is_nullable: bool = false

var _has_options: bool = false
var _options: Array

## Sets the name of the JSON property that this validator corresponds to
func property(value: String) -> JPropertyValidator:
	key = value
	return self


func is_optional(value: bool = true) -> JPropertyValidator:
	_is_optional = value
	return self


func is_nullable(value: bool = true) -> JPropertyValidator:
	_is_nullable = value
	return self


func options(value: Array = []) -> JPropertyValidator:
	_has_options = true
	_options = value
	return self


@warning_ignore("unused_parameter")
## If [code]true[/code], the [code]data[/code] argument is valid
func is_valid(data) -> bool:
	if data == null: return _is_nullable
	elif _has_options: return data in _options
	else: return true


## If [code]true[/code], the value of [member key] in [code]data[/code] is valid
func is_json_valid(data: Dictionary) -> bool:
	if key in data: return is_valid(data[key])
	else: return _is_optional


@warning_ignore("unused_parameter")
func cleaned_data(data, default = null):
	return data if is_valid(data) else default


func cleaned_json_data(data: Dictionary, default := {}) -> Dictionary:
	data[key] = cleaned_data(data[key], default.get(key))
	return data


static func from_schema(schema: Dictionary) -> JPropertyValidator:
	match schema.get("type"): 
		"array": return JArrayValidator.from_schema(schema)
		"boolean": return JBoolValidator.from_schema(schema)
		"integer": return JIntValidator.from_schema(schema)
		"number": return JNumberValidator.from_schema(schema)
		"object": return JsonValidator.from_schema(schema)
		"string": return JStringValidator.from_schema(schema)
		_: return null
