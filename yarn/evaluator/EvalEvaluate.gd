class_name EvalEvaluate

var tree

func get_value(key, dict):
	if key in dict:
		return dict[key]
	else:
		return false
		
func _init(_tree):
	tree = _tree
	
# Shorthand :X
const Op = EvalNode.OpType

# differentiates between string literals, variable names, and booleans
func eval_string(string, env):
	if "\"" in string:
		return string.replace("\"", "")
	else:
		if string == "true" or string == "TRUE":
			return true
		if string == "false" or string == "FALSE":
			return false
		return env.get(string)

# handle overload of + operator for strings and numbers
func add_concat(a, b):
	if typeof(b) == TYPE_STRING or typeof(a) == TYPE_STRING:
		return str(a) + str(b)
	else:
		return a + b

func eval_expr(node, env):
	if node == null:
		return 0
	var lhs = eval_expr(node.left, env)
	var rhs = eval_expr(node.right, env)
	# ints defined in the environment won't be compared for equality 
	# correctly unless they're cast to floats
	if lhs is int:
		lhs = float(lhs)
	if rhs is int:
		rhs = float(rhs)
	match node.op:
		Op.ADD: return add_concat(lhs, rhs)
		Op.SUB: return lhs - rhs
		Op.MUL: return lhs * rhs
		Op.DIV: return lhs / rhs
		Op.LEQ: return lhs <= rhs
		Op.LT: return lhs < rhs
		Op.GEQ: return lhs >= rhs
		Op.GT: return lhs > rhs
		Op.EQ: return (lhs == rhs if typeof(lhs) == typeof(rhs) else false)
		Op.NEQ: return (lhs != rhs if typeof(lhs) == typeof(rhs) else true)
		Op.AND: return lhs and rhs
		Op.OR: return lhs or rhs
		Op.SYMBOL: return eval_string(node.value, env)
		Op.NUM: return node.value
		Op.NOT: return not rhs
	
# Takes a dict<string, real>
# outputs the result of the evaluation
func evaluate(env):
	return eval_expr(tree, env)
