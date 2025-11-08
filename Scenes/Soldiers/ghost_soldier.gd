extends Node2D

var origin: Vector2
var victims: Array = []
var SelectionMode: bool = false

func _process(delta):
	Select()
	

func Select() -> void:
	if SelectionMode == true and Input.is_action_just_pressed("ui_accept"):
		GV.GameHandler.BOARD.moveSoldier(origin, victims, self.global_position)
		GV.GameHandler.playSound("res://Audio/MoveSound.mp3")
		GV.GameHandler.BOARD.resetSelection(null)
	

func setVictims(vics: Array) -> void:
	victims = vics
	

func _on_mouse_entered() -> void:
	SelectionMode = true
	

func _on_mouse_exited() -> void:
	SelectionMode = false
	
