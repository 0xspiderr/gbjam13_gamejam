extends Node


@onready var music_stream_player: AudioStreamPlayer = $MusicStreamPlayer
@onready var sfx_stream_player: AudioStreamPlayer = $SfxStreamPlayer

#region MUSIC PATHS
const COMBAT = "res://sounds/music/Combat.ogg"
const MAIN_MENU_OGG = "res://sounds/music/MainMenuOGG.ogg"
const OVERWORLD = "res://sounds/music/Overworld.ogg"
#endregion

#region SFX PATHS
const DOOR_OPEN = "res://sounds/sfx/DoorOpen.ogg"
const FLIP_CARD = "res://sounds/sfx/FlipCard.ogg"
const DIALOGUE_1 = "res://sounds/dialogue/Dialogue1.ogg"
const DIALOGUE_2 = "res://sounds/dialogue/Dialogue2.ogg"
const DIALOGUE_3 = "res://sounds/dialogue/Dialogue3.ogg"
#endregion


func change_music_stream(path: String) -> void:
	music_stream_player.stop()

	var stream = AudioStreamOggVorbis.load_from_file(path)
	stream.loop = true
	music_stream_player.stream = stream
	music_stream_player.play()


func play_sfx(path: String, is_looping: bool) -> void:
	var stream = AudioStreamOggVorbis.load_from_file(path)
	stream.loop = is_looping
	sfx_stream_player.stream = stream
	sfx_stream_player.play()


func stop_sfx() -> void:
	sfx_stream_player.stop()
