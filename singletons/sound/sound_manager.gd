extends Node


@onready var music_stream_player: AudioStreamPlayer = $MusicStreamPlayer
const COMBAT = "res://sounds/Combat.ogg"
const MAIN_MENU_OGG = "res://sounds/MainMenuOGG.ogg"

func change_music_stream(path: String) -> void:
	music_stream_player.stop()
	
	var stream = AudioStreamOggVorbis.load_from_file(path)
	stream.loop = true
	music_stream_player.stream = stream
	music_stream_player.play()
