class_name JPropertyValidator extends Object

## The name of the JSON property that this validator corresponds to
var key: String

var _is_optional: bool = false
var _is_nullable: bool = false

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


@warning_ignore("unused_parameter")
## If [code]true[/code], the [code]data[/code] argument is valid
func is_valid(data) -> bool:
	if data == null: return _is_nullable
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
