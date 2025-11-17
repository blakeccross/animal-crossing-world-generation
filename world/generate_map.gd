extends Node3D

const GRID_SIZE = 4
const tiles = preload("res://world/acre_connections.gd").tiles
const acre_dictionary = preload("res://world/acres_dictionary.gd").acres_dictionary
const curved_shader = preload("res://shaders/curved_world.gdshader")

@onready var grid_map = $GridMap

var grid: Array = []
var rng = RandomNumberGenerator.new()

var hasUsedRiverSplit: bool

func _ready():
	initialize_grid()
	generate_map()
	display_grid()
	place_tiles_in_grid_map()
	apply_shader()

func initialize_grid():
	grid.clear()
	grid = []
	hasUsedRiverSplit = false
	# Add 1 to Grid size to have the river appear to flow
	# into the ocean
	for y in range(GRID_SIZE + 1):
		var row = []
		for x in range(GRID_SIZE):
			row.append([])
			
		grid.append(row)

func apply_curved_shader_to_acres():
	return


func generate_map():
	var max_attempts = 5  # Limit the number of retries
	var attempts = 0
	var success = false
	
	while not success and attempts < max_attempts:
		attempts += 1
		print("River generation attempt %d" % attempts)
		var town_water_source_x = generate_town_entrance_gate_and_water_source()
		var river_success = generate_river(town_water_source_x, 0)
		place_bridges()
		replace_bottom_of_map_with_beach()
		var buildings_success = place_building_acres()
		fill_empty_acres()
		
		if not river_success or not buildings_success:
				print("River generation failed, retrying...")
				initialize_grid()  # Restart the process
		else:
			success = true
	
	if not success:
		print("Failed to generate river after %d attempts." % max_attempts)
		
		
func generate_town_entrance_gate_and_water_source():
	# Randomly place a "house" tile in either (0, 1) or (0, 2)
	var town_entrance_gate_x = rng.randi_range(1, 2)
	grid[0][town_entrance_gate_x] = ["town_entrance_gate"]

	var town_water_source_x = rng.randi_range(0, 3)
	while town_water_source_x == town_entrance_gate_x:
		town_water_source_x = rng.randi_range(0, 3)
	grid[0][town_water_source_x] = ["pond_to_south"]
	return town_water_source_x
	
	
	
func generate_river(start_x: int, start_y: int) -> bool:
	var current_x = start_x
	var current_y = start_y
	
	while current_y < GRID_SIZE:
		var possible_directions = ["south", "east", "west"]
		var valid_tiles = []
		
		# Check each possible direction for valid river tiles
		for direction in possible_directions:
			var next_x = current_x
			var next_y = current_y
			
			if direction == "south":
				next_y += 1
			elif direction == "east" and current_x < GRID_SIZE - 1:
				next_x += 1
			elif direction == "west" and current_x > 0:
				next_x -= 1
			
			# Get valid tiles based on the current river tile's connections
			var current_tile = grid[current_y][current_x][0]
			
			# Add 1 so that the river is allowed to over flow and then we replace bottom tiles with beach
			if next_y < GRID_SIZE + 1 and tiles.has(current_tile):
				var allowed_tiles = tiles[current_tile][direction]
				#.filter(func(value): return value != "river_north_div_west_east" and value != "river_north_div_east_south")
					
				# If there are valid tiles and the direction is empty
				if allowed_tiles.size() > 0 and grid[next_y][next_x].size() == 0:
					var edge_filtered_tiles = []
					
					for tile in allowed_tiles:
						#print(tile, " - XY ", next_x, next_y, "\nCan Exit - ",tile_can_exit(tile, tiles, grid, next_x, next_y), "\nNot Recently Used - ",is_tile_not_recently_used(tile, current_tile, edge_filtered_tiles),"\nValid beach tile - ",is_valid_beach_tile(tile, next_y),"\nRvier Split - ",is_not_river_split_or_not_already_used(tile, hasUsedRiverSplit))
						
						if tile_can_exit(tile, tiles, grid, next_x, next_y) and is_tile_not_recently_used(tile, current_tile, edge_filtered_tiles) and is_valid_beach_tile(tile, next_y) and is_not_river_split_or_not_already_used(tile, hasUsedRiverSplit):
							edge_filtered_tiles.append(tile)
							
					if edge_filtered_tiles.size() > 0:
						
						valid_tiles.append([next_x, next_y, edge_filtered_tiles])

		# Pick a random valid tile and update the grid
		if valid_tiles.size() > 0:
					
			# TODO need to figure out how to continue rivers with more than one stream
			for i in valid_tiles.size():
				var next_tile_info = valid_tiles[i]
				var next_x = next_tile_info[0]
				var next_y = next_tile_info[1]
				var next_tile_options = next_tile_info[2]
				var next_tile = next_tile_options[rng.randi_range(0, next_tile_options.size() - 1)]
				
				if (next_tile.contains("_div_") and hasUsedRiverSplit == false):
					hasUsedRiverSplit = true
				
				grid[next_y][next_x] = [next_tile]
				
				# If the river splits we need generate a river at the split
				if i > 0:
					generate_river(next_x, next_y)
				else:
					current_x = next_x
					current_y = next_y
				

		else:
			# No valid tiles
			print("No valid tiles from (%d, %d) " % [current_y, current_x],grid[current_y][current_x][0])
			return false
			#break
	
	return true



func place_bridges():
	var river_tiles = []

	# Collect all river tiles
	for y in range(GRID_SIZE):
		for x in range(GRID_SIZE):
			if grid[y][x].size() > 0 and grid[y][x][0].contains("river_") and not grid[y][x][0].contains("_div_"):
				river_tiles.append(Vector2(x, y))

	# Select 2 or 3 river tiles for bridges depending on if a split is present
	var num_bridges = 2
	if hasUsedRiverSplit:
		num_bridges = 3
	var bridge_tiles = []
	
	while bridge_tiles.size() < num_bridges and river_tiles.size() > 0:
		var random_index = rng.randi_range(0, river_tiles.size() - 1)
		var tile_pos = river_tiles.pop_at(random_index)
		bridge_tiles.append(tile_pos)

		# Update the grid with a bridge at the selected tile
		var x = tile_pos.x
		var y = tile_pos.y
		var current_tile = grid[y][x][0]
		
		if not current_tile.contains("_bridge"):  # Ensure no duplicate bridges
			grid[y][x][0] = current_tile + "_bridge"

	# Log the bridge placements
	print("Bridges placed at:", bridge_tiles)


func replace_bottom_of_map_with_beach():
	# Replace the last row with "beach" tiles or empty lists
	for x in range(GRID_SIZE):
		if (grid[GRID_SIZE - 1][x].size() > 0):
			var tile_name = grid[GRID_SIZE - 1][x][0]
		
			grid[GRID_SIZE - 1][x] = ["beach_" + tile_name]
		else:
			grid[GRID_SIZE - 1][x] = ["beach"]



func tile_can_exit(tile, tiles, grid, next_x, next_y) -> bool:
	var can_exit = false
	
	#For all none edge pieces
	if next_x != 0 and next_x != GRID_SIZE - 1:
		can_exit = true
	# If tiles is on far left or right edge, filter out tiles that would result in a dead end
	if next_x == 0 and tiles[tile]["west"].size() == 0 and (grid[next_y][next_x + 1].size() == 0 or tiles[tile]["south"].size() > 0): # Left edge
		can_exit = true
	elif next_x == GRID_SIZE - 1 and tiles[tile]["east"].size() == 0 and (grid[next_y][next_x - 1].size() == 0 or tiles[tile]["south"].size() > 0): # Right edge
		can_exit = true
	return can_exit
	
	
	
func is_valid_beach_tile(tile, next_y) -> bool:
	# Filter out none beach tiles
	if (next_y < GRID_SIZE - 1):
		return true
	# make sure there are no river splits on the beach
	return not tile.contains("_div_") and tile != "river_west_to_east" and tile != "river_east_to_west"



func is_not_river_split_or_not_already_used(tile, hasUsedRiverSplit) -> bool:
	if not tile.contains("_div_"):
		return true
	elif hasUsedRiverSplit == false:
		return true
	return false



func is_tile_not_recently_used(tile, current_tile, allowed_tiles) -> bool:
	# This tries to determine if a tile was just used previously
	return tile != current_tile or (tile == current_tile and allowed_tiles.size() == 1)


func place_building_acres() -> bool:
	var buildings = ["museum","player_home","town_hall","shops"]
	var open_tiles = []
	
	# Collect all open tiles
	for y in range(GRID_SIZE):
		for x in range(GRID_SIZE):
			if grid[y][x].size() == 0:  # Check if the tile is empty
				open_tiles.append(Vector2(x, y))

	# Shuffle the open tiles to ensure randomness
	open_tiles.shuffle()

	# Place buildings in the open tiles
	for building in buildings:
		if open_tiles.size() > 0:
			var tile_pos = open_tiles.pop_front()  # Get an open tile position
			grid[tile_pos.y][tile_pos.x] = [building]
		else:
			print("Not enough open tiles to place all buildings.")
			break
			return false
			
	return true


func fill_empty_acres():
	var open_tiles = []
		
	# Collect all open tiles
	for y in range(GRID_SIZE):
		for x in range(GRID_SIZE):
			if grid[y][x].size() == 0:
				grid[y][x] = ["grass"]
		


func display_grid():
	for y in range(GRID_SIZE):
		print("Row %d: %s" % [y, grid[y]])
		
		
# Place tiles in the GridMap after the grid is collapsed
func place_tiles_in_grid_map():
	for y in range(GRID_SIZE):
		for x in range(GRID_SIZE):
			if len(grid[y][x]) == 1:
				var tile_name = grid[y][x][0]

				var selected_acre_variation = select_acre_variation(tile_name)
				grid_map.set_cell_item(Vector3i(x, 0, y), search_mesh_in_library(selected_acre_variation), 0)


func select_acre_variation(tile_name: String):
	var acre_variations = []
	
	if tile_name.contains("_bridge"):
		acre_variations = acre_dictionary[tile_name.replace("_bridge", "")]["bridge"]
	else:
		acre_variations = acre_dictionary[tile_name]["tiles"]
	
	return acre_variations[rng.randi_range(0, acre_variations.size() - 1)]


func search_mesh_in_library(search_name: String) -> int:
	var mesh_library = grid_map.mesh_library
	return mesh_library.find_item_by_name(search_name)

func apply_shader():
	for mesh in $GridMap.get_meshes():
		if mesh is Mesh:
			for i in range(mesh.get_surface_count()):
				var material = mesh.surface_get_material(i)

				if material is BaseMaterial3D:
					var shader_material = ShaderMaterial.new()
					shader_material.shader = curved_shader
					
					# Copy the albedo texture
					var albedo_texture = material.albedo_texture
					
					if albedo_texture:
						shader_material.set_shader_parameter("albedo_texture", albedo_texture)
						
						# Copy other material properties if needed
						shader_material.set_shader_parameter("roughness", material.roughness)
						shader_material.set_shader_parameter("metallic", material.metallic)
						shader_material.set_shader_parameter("albedo_color", material.albedo_color)
						
						# Apply the ShaderMaterial back to the mesh surface
						mesh.surface_set_material(i, shader_material)
