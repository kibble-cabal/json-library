class_name JStringValidator extends JPropertyValidator

var _min_length_is_set: bool = false
var _min_length: int = 0

var _max_length_is_set: bool = false
var _max_length: int = 0

## Sets the validator to check for a minimum number of characters (inclusive, so "abc" with a minimum length of 3 is valid)
func min_length(value: int) -> JStringValidator:
	_min_length = value
	_min_length_is_set = true
	return self


## Sets the validator to check for a maximum number of characters (inclusive, so "abc" with a maximum length of 3 is valid)
func max_length(value: int) -> JStringValidator:
	_max_length = value
	_max_length_is_set = true
	return self


func is_valid(data) -> bool:
	return (
		data is String
		and (data.length() >= _min_length if _min_length_is_set else true)
		and (data.length() <= _max_length if _max_length_is_set else true)
	)
