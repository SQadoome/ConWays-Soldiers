class_name Board
extends Node2D

@export var SoldiersMap: TileMapLayer
@export var BackGroundMap: TileMapLayer
@export var Ghosts: Node2D
var SelectedSoldier: Soldier
var GridSize: Vector2

func _ready() -> void:
	GenerateMap()
	

func GenerateMap() -> void:
	SoldiersMap.clear()
	BackGroundMap.clear()
	GridSize = Vector2(50, 30)
	generateSoldiers()
	generateLevels()
	

func generateSoldiers() -> void:
	var rows = GridSize.x/2
	var columns = GridSize.y/2
	for row in rows:
		for column in columns:
			createSoldier(Vector2(row, column))
			createSoldier(Vector2(-row, column))
	

func generateLevels() -> void:
	var amount = GridSize.x/2
	var levels = 15
	var level
	for x in amount:
		for y in levels:
			if y <= 7:
				level = y
			BackGroundMap.set_cell(Vector2(x, -y-1), 0, Vector2(level, 0), 0)
			BackGroundMap.set_cell(Vector2(-x, -y-1), 0, Vector2(level, 0), 0)
	for row in amount:
		for column in GridSize.y/2:
			BackGroundMap.set_cell(Vector2(row, column), 0, Vector2(8, 0), 0)
			BackGroundMap.set_cell(Vector2(-row, column), 0, Vector2(8, 0), 0)
			
	

func resetSelection(new_soldier: Soldier) -> void:
	if SelectedSoldier != null:
		SelectedSoldier.unSelect()
	if new_soldier != null:
		SelectedSoldier = new_soldier
	else:
		SelectedSoldier = null
	deleteGhosts()

func createSoldier(cell: Vector2) -> void:
	SoldiersMap.set_cell(cell, 0, Vector2(0, 0), randi_range(1, 2))
	

func getAxisSoldiers(at_pos: Vector2) -> Array:
	var soldiers = []
	var directions = [Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN]
	var cell = Vector2(SoldiersMap.local_to_map(at_pos))
	
	for i in directions:
		if SoldiersMap.get_cell_source_id(cell+i) != -1:
			soldiers.append(i)
	
	return soldiers

func getDiagonalSoldiers(at_pos: Vector2) -> Array:
	var soldiers = []
	var directions = [Vector2(1, 1), Vector2(-1, 1), Vector2(1, -1), Vector2(-1, -1)]
	var cell = SoldiersMap.local_to_map(at_pos)
	for i in directions:
		if SoldiersMap.get_cell_source_id(cell+i) != -1:
			soldiers.append(i)
	
	return soldiers

func getSurroundingSoldiers(at_pos: Vector2) -> Array:
	return getAxisSoldiers(at_pos) + getDiagonalSoldiers(at_pos)

func moveSoldier(start_pos: Vector2, victims: Array, target_pos: Vector2) -> void:
	var start_cell = SoldiersMap.local_to_map(start_pos)
	var finish_cell = SoldiersMap.local_to_map(target_pos)
	for i in victims:
		SoldiersMap.erase_cell(i)
	SoldiersMap.erase_cell(start_cell)
	createSoldier(finish_cell)

func setSoldier(at_pos: Vector2) -> bool:
	var success = false
	return success

func getAxisLocations(at_pos: Vector2) -> Array:
	var locations = []
	var cell = Vector2(SoldiersMap.local_to_map(at_pos))
	var directions = [Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN]
	for i in directions:
		if SoldiersMap.get_cell_source_id(cell + i*1) != -1 and SoldiersMap.get_cell_source_id(cell + i*2) == -1:
			locations.append(cell + i*2)
	
	return locations

func getLongJumpLocations(at_pos: Vector2) -> Array:
	var locations = []
	var cell = Vector2(SoldiersMap.local_to_map(at_pos))
	var directions = [Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN]
	for i in directions:
		if SoldiersMap.get_cell_source_id(cell + i*1) != -1 and SoldiersMap.get_cell_source_id(cell + i*2) != -1 and SoldiersMap.get_cell_source_id(cell + i*3) == -1 and SoldiersMap.get_cell_source_id(cell + i*4) == -1:
			locations.append(cell + i*4)
	
	return locations
	

func getDiagonalLocations(at_pos: Vector2) -> Array:
	var locations = []
	var cell = Vector2(SoldiersMap.local_to_map(at_pos))
	var directions = [Vector2(1, 1), Vector2(-1, 1), Vector2(1, -1), Vector2(-1, -1)]
	for i in directions:
		if SoldiersMap.get_cell_source_id(cell + i*1) != -1 and SoldiersMap.get_cell_source_id(cell + i*2) == -1:
			locations.append(cell + i*2)
	
	return locations
	

func getAvailableLocations(at_pos: Vector2, move_data: Array) -> Array:
	var location_data = []
	if move_data.is_empty():
		return []
	if move_data.has("axis"):
		location_data += getAxisLocations(at_pos)
	if move_data.has("diagonals"):
		location_data += getDiagonalLocations(at_pos)
	if move_data.has("long"):
		location_data += getLongJumpLocations(at_pos)
	
	return location_data

func createGhosts(from: Vector2, locations: Array) -> void:
	for i in locations:
		var new_ghost = load("res://Scenes/Soldiers/ghost_soldier.tscn").instantiate()
		Ghosts.add_child(new_ghost)
		new_ghost.global_position = SoldiersMap.map_to_local(i)
		new_ghost.origin = from
		new_ghost.setVictims(calculateVictims(SoldiersMap.local_to_map(from), i))
	

func calculateVictims(from: Vector2, to: Vector2) -> Array:
	var victims = []
	var direction = sign(to-from)
	var cell = to - direction
	var safety = 0
	while cell != from and safety < 10:
		victims.append(cell)
		cell -= direction
		safety += 1
	
	return victims

func deleteGhosts() -> void:
	for i in Ghosts.get_children():
		i.queue_free()
	
