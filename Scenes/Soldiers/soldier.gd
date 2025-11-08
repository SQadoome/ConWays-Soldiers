class_name Soldier
extends Node2D

var SelectionMode: bool = false
var CurrentHeight: int = 0
var Selected: bool = false

func _ready() -> void:
	UpdateShader()
	if CurrentHeight == 0:
		$CPUParticles2D.emitting = false
	

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") and SelectionMode:
		select()
	if event.is_action_pressed("ui_cancel"):
		unSelect()
	

func select() -> void:
	GV.GameHandler.BOARD.resetSelection(self)
	get_node("Highlight").show()
	GV.GameHandler.BOARD.createGhosts(global_position, GV.GameHandler.BOARD.getAvailableLocations(global_position, ["axis", "diagonals", "long"]))

func unSelect() -> void:
	get_node("Highlight").hide()
	

func UpdateShader() -> void:
	if position.y < 0:
		CurrentHeight = abs(position.y - 32)/64
		$CPUParticles2D.emitting = true
		$CPUParticles2D.amount = abs(CurrentHeight*2)
		$Shiny.color = Color(1, 1, 1, CurrentHeight/20.0)
	var intensity = (CurrentHeight*2.0)/100.0
	get_node("Sprite2D").material.set_shader_parameter("influence", intensity)
	

func CalculateScore() -> int:
	if ((CurrentHeight+1)^2)-(GV.Settings["Gameplay"]["BoardSize"].x/16) > 0 and CurrentHeight > 0:
		return ((CurrentHeight+1)^2)-(GV.Settings["Gameplay"]["BoardSize"].x/16)
	else:
		return 0
	


func _on_mouse_entered() -> void:
	SelectionMode = true
	

func _on_mouse_exited() -> void:
	SelectionMode = false
	
