extends Node


@onready var music_stream_player: AudioStreamPlayer = $MusicStreamPlayer

#region MUSIC PATHS
const COMBAT = "res://sounds/Combat.ogg"
const MAIN_MENU_OGG = "res://sounds/MainMenuOGG.ogg"

#endregion


func change_music_stream(path: String) -> void:
	music_stream_player.stop()
	
	var stream = AudioStreamOggVorbis.load_from_file(path)
	stream.loop = true
	music_stream_player.stream = stream
	music_stream_player.play()
