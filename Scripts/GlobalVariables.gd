extends Node

var GameHandler

func _ready() -> void:
	GameHandler = get_tree().root.get_node("GameHandler")
	

var Settings: Dictionary = {
	"Gameplay": {
		"DiagonalMoves": false,
		"BoardSize": Vector2(32, 26)
	}
}
