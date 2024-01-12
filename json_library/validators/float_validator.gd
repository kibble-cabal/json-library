class_name JFloatValidator extends JNumberValidator

## Handles validation and cleanup of [float] data

## If the provided [code]data[/code] is a valid [float], returns [code]data[/code]. Otherwise, returns [code]default[/code].
func cleaned_data(data, default = 0.0) -> float:
	if not is_valid(data): return default
	return (
		data if data is float 
		else float(data) if data is int 
		else default
	)
