class_name traps

func speed_trap(n: bool) -> float:
	var slow : float
	if n:
		slow  = 50.0
	else:
		slow = 200.0
	return slow

func friction_trap (n: bool) -> float:
	var friction: float 
	if n:
		friction = 200.0
	else:
		friction = 1000.0
	return friction
