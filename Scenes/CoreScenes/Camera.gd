extends Camera2D

var dead_zone: Vector2 = Vector2(0, 128)

func _ready() -> void:
	UpdateDeadZone()
	

func UpdateDeadZone() -> void:
	dead_zone.x = GV.Settings["Gameplay"]["BoardSize"].x/2*32
	if GV.Settings["Gameplay"]["BoardSize"] == Vector2(32, 26):
		dead_zone.x = 0
	

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if event.button_mask == MOUSE_BUTTON_MASK_MIDDLE:
			if position.x - event.relative.x < dead_zone.x and position.x - event.relative.x > -1*dead_zone.x:
				position.x -= event.relative.x
			if position.y - event.relative.y < dead_zone.y and position.y - event.relative.y > -1*dead_zone.y:
				position.y -= event.relative.y
