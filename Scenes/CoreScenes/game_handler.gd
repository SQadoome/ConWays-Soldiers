extends Node2D

var SelectedSoldier

@onready var CoinSFX: AudioStream = load("res://Audio/MoveSound.mp3")
@onready var BOARD: Board = get_node("CanvasLayer/BoardManager")

func playSound(audio_file: String) -> void:
	var new_stream = load(audio_file)
	get_node("AudioStreamPlayer").stream = new_stream
	get_node("AudioStreamPlayer").play()
	
