extends Control

var SizeList: Array = [Vector2(32, 26), Vector2(64 , 26), Vector2(96 , 26)]

func _on_dg_moves_toggled(toggled_on: bool) -> void:
	GV.Settings["Gameplay"]["DiagonalMoves"] = toggled_on
	

func _on_item_list_item_selected(index: int) -> void:
	GV.Settings["Gameplay"]["BoardSize"] = SizeList[index]
	GV.GameHandler.Reset()
	

func _on_undo_pressed() -> void:
	GV.GameHandler.UndoLastMove()
	

func _on_reset_pressed() -> void:
	GV.GameHandler.Reset()
	
