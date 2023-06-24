class_name JFloatValidator extends JNumberValidator


func cleaned_data(data, default = 0.0) -> float:
	return (
		data if data is float 
		else float(data) if data is int 
		else default
	)
