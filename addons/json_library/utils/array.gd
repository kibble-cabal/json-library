class_name JsonLibrary_Utils_Array extends Object


static func map_to_lower(array: Array) -> Array:
	return array.map(func(element: String) -> String: return element.to_lower())
