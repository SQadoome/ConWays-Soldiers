class_name MusicPlayer
extends AudioStreamPlayer

var song_pool: Array[String] = []

func _ready() -> void:
	finished.connect(changeSong)
	song_pool.append("res://Audio/Music/penroses_patterns.mp3")
	song_pool.append("res://Audio/Music/firefly_in_a_fairytale.mp3")
	changeSong()

func changeSong() -> void:
	var new_stream = load(song_pool[randi_range(0, song_pool.size() - 1)])
	stream = new_stream
	play()
