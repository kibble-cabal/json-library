class_name JEnumValidator extends JPropertyValidator

## Handles validation and cleanup of a value based on a provided enum
##
## This is similar to [member JPropertyValidator.options], except instead of providing a list of values,
## you provide a [Dictionary] of [String] keys and [Variant] values. Valid data is one of the enumerated
## [String] keys.
## [br][br]
## This is handy when working with Godot's enums, where you want to correspond a [String] name to an [int] value.
## Because this is a Godot-specific feature, this type of validator can only be created through code, and
## not JSON schemas using the [method JPropertyValidator.from_schema] method.

## A [Dictionary][[String] keys, [Variant] values] containing the enumerated options.
## [br]Most custom [code]enum[/code]s can be passed directly in:
## [codeblock]
## enum MyEnum { OPTION_A, OPTION_B }
## JEnumValidator.new(MyEnum) # this works
## [/codeblock]
var enum_dict: Dictionary

## If [code]true[/code], the validator will restrict the valid data further. Only keys in [member allowed_options] will be considered valid.
var has_allowed_options := false

## If [member has_allowed_options] is [code]true[/code], only [member enum_dict] keys contained in this [Array][[String]] will be considered valid.
var allowed_options: Array[String] = []

## If [code]true[/code], the validator will consider case when comparing [member enum_dict] keys.
## [br][b]Example:[/b]
## [codeblock]
## enum MyEnum { OPTION_A, OPTION_B }
## assert(JEnumValidator.new(MyEnum).is_valid("option_a") == false)
## assert(JEnumValidator.new(MyEnum).set_case_sensitive(false).is_valid("option_a") == true)
## [/codeblock]
var case_sensitive := true


func _init(enum_value: Dictionary = {}) -> void:
	enum_dict = enum_value


## Set the validator to be case (in)sensitive (see [member case_sensitive])
func set_case_sensitive(value: bool = true) -> JEnumValidator:
	case_sensitive = value
	return self


## Adds the provided [code]options[/code] to [member allowed_options]
func allow_options(options: Array[String]) -> JEnumValidator:
	has_allowed_options = true
	allowed_options.append_array(options)
	return self


## Returns [code]true[/code] if [code]data[/code] is a valid [String] based on the properties of this [JEnumValidator] object.
## [br][b]Example:[/b]
## [codeblock]
## enum MyEnum { A = 1, B = 2, X = 3, Y = 4 }
## assert(JEnumValidator.new(MyEnum)
##     .set_case_sensitive(false)
##     .allow_options(["a", "b"])
##     .is_valid("a"))
## [/codeblock]
func is_valid(data) -> bool:
	if data == null: return is_nullable
	if not data is String: return false
	if not case_sensitive:
		if Json.Dict.has_key_case_insensitive(enum_dict, data):
			if has_allowed_options: return data.to_lower() in Json.List.map_to_lower(allowed_options)
			else: return true
		else: return false
	else: 
		if has_allowed_options: return data in enum_dict and data in allowed_options
		else: return data in enum_dict


## If the provided [code]data[/code] is a valid key of [member enum_dict], returns the corresponding
## VALUE in [member enum_dict].
## [br][b]Example:[/b]
## [codeblock]
## enum MyEnum { OPTION_A = 1, OPTION_B = 2 }
## assert(JEnumValidator.new(MyEnum).cleaned_data("OPTION_A") == 1)
## [/codeblock]
func cleaned_data(data, default = 0) -> int:
	if not is_valid(data): return default
	if not case_sensitive: return Json.Dict.get_case_insensitive(enum_dict, data, default)
	else: return enum_dict.get(data, default)
