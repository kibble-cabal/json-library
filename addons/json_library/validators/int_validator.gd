class_name JIntValidator extends JNumberValidator


func is_valid(data) -> bool:
	if data == null: return _is_nullable
	return super.is_valid(data) and Json.Utils.Math.is_rounded(data)


func cleaned_data(data, default = 0) -> int:
	return (
		roundi(data) if data is float
		else data if data is int
		else default
	)
