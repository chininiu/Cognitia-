extends TileMapLayer
class_name DFS

@onready var shapeA = %spawner_area
var cell_coords :Array= [Vector2(0,-1), Vector2(0,1),
				Vector2(1,0),Vector2(-1,0)]
var no_questions:int
var no_even:int
var direction : int
static var orb_places : Array = []
signal maze_finished

func _ready():
	randomize()
	no_questions = global_var.questions_arr.size()
	if no_questions > 8:
		no_questions=8
	#this if-else modifies the no_even. this should be implemented for the perfect maze gen no loops
	if no_questions % 2 == 0:
		no_even  = no_questions + 1
	else:
		no_even = no_questions
	if global_var.linearMaze and !global_var.qrMaze:
		gen_perfect_maze()
	elif !global_var.linearMaze and global_var.qrMaze:
		gen_maze_qr()
	print(no_questions)
	
func avail_neighbors(cell, unvisited) -> Array:
	#return an array of available neighbors
	var list = []
	#adding all the cell_coords to cell to check if there is available cell to move
	for n in range(cell_coords.size()):
		if (cell + cell_coords[n]) in unvisited:
			list.append(cell + cell_coords[n])
	return list
	
func gen_maze_qr():
	var unvisited = []
	var stack = []
	var width :int = (shapeA.shape.size.x/32) * no_even
	var height :int = (shapeA.shape.size.y/32) * no_even
	var deadend :bool=false;
	var place_wall_if_2 :int= 1
	var wall = false
	var temp_neighbors:Array =[]
	var is_stack: bool = false
	var prev_dir:Vector2
	var current_dir:Vector2 = Vector2(0,0)
	#set all the cells unvisited
	for x in range(width):
		for y in range(height):
			unvisited.append(Vector2(x,y))
			set_cell(Vector2(x,y),1,Vector2(0,0),0)
	var current = Vector2(0,0)
	unvisited.erase(current)
	#actual DFS
	while unvisited.size() > 0:
		var neighbors :Array= avail_neighbors(current, unvisited)
		if neighbors.size() > 0:
			# DIR_Val pick randomly from the available naighbors
			var dir_val = randf_range(0, neighbors.size())
			var dir = neighbors[dir_val]
			set_cell(current,1,Vector2(0,1),0)
			var prev_current = current
			current = dir
			unvisited.erase(dir)
			stack.append(dir)
			if current is Vector2 && !is_stack:
				prev_dir = current_dir
				current_dir = current- prev_current
				if prev_dir != current_dir:
					orb_places.append(prev_current)
			is_stack = false
			deadend = false
			if wall:
				for n in temp_neighbors:
					set_cell(n,1,Vector2(0,0),0)
					unvisited.erase(n)
				temp_neighbors.clear()
				wall= false
			if place_wall_if_2 == 2:
				for n in neighbors:
					temp_neighbors.append(n)
				temp_neighbors.erase(current)
				place_wall_if_2 = 0
				wall = true
			place_wall_if_2 = place_wall_if_2 + 1
		elif stack and neighbors.size() == 0:
			if !deadend:
				set_cell(current,1,Vector2(0,0),0)
				deadend=true
				is_stack = true
			current = stack.pop_back()
		if stack.size()== 0:
			break
		await get_tree().create_timer(0.01).timeout
	orb_places.erase(Vector2(0,0))
	emit_signal("maze_finished")

func gen_perfect_maze():
	var unvisited = []
	#stack is the alocated memory for the coordinates we've taken
	var stack = []
	var prev_dir:Vector2
	var current_dir:Vector2 = Vector2(0,0)
	var width :int = (shapeA.shape.size.x/32) * no_even
	var height :int = (shapeA.shape.size.y/32) * no_even
	var is_stack: bool = false
	#set all the cells unvisited
	for x in range(width):
		for y in range(height):
			set_cell(Vector2(x,y),1,Vector2(0,0),0)
			unvisited.append(Vector2(x,y))
			#set_cell(Vector2(x,y),1,Vector2(0,0),0)
			#odd coordinates in unvisited will be set as visited/erased in unvisited
			for odd in unvisited:
				if int(odd.x) % 2 > 0 && int(odd.y) % 2 > 0:
					set_cell(Vector2(odd),1,Vector2(0,0),0)
					unvisited.erase(odd)
	var current = Vector2(0,0)
	#current position will be marked as visited/erased from unvisited
	unvisited.erase(current)
	# the actual DFS
	while unvisited.size() > 0:
		var neighbors :Array= avail_neighbors(current, unvisited)
		if neighbors.size() > 0:
			# DIR_Val pick randomly from the available naighbors
			var dir_val = randf_range(0, neighbors.size())
			var dir = neighbors[dir_val]
			set_cell(current,1,Vector2(0,1),0)
			var prev_current = current
			current = dir
			#Next direction will be mark as visited
			unvisited.erase(dir)
			if current is Vector2 && !is_stack:
				prev_dir = current_dir
				#checks if the ground change direction by comparing the previous and current direction.
				# current - prev current should return the previous current dir, if not, then the ground changed its position.
				current_dir = current- prev_current
				if prev_dir != current_dir:
					orb_places.append(prev_current)
			is_stack = false
			stack.append(dir)
		
		elif stack:
			#if there is no neighbors in current position, the current position will take
			#the last position (Array.pop_back()) to check if there is more neighbors 
			#to move on
			current = stack.pop_back()
			is_stack = true
		elif !stack:
			break
		await get_tree().create_timer(0.01).timeout
	orb_places.erase(Vector2(0,0))
	emit_signal("maze_finished")
