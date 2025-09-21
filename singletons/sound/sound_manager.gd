extends Node


@onready var music_stream_player: AudioStreamPlayer = $MusicStreamPlayer
@onready var sfx_stream_player: AudioStreamPlayer = $SfxStreamPlayer

#region MUSIC PATHS
@onready var COMBAT = preload("res://sounds/music/Combat.ogg")
@onready var COMBAT_LEVEL = preload("res://sounds/music/Combat2.ogg")
@onready var MAIN_MENU_OGG = preload("res://sounds/music/MainMenuOGG.ogg")
@onready var OVERWORLD = preload("res://sounds/music/BeepBox-Song (1).mp3")
#endregion

#region SFX PATHS
@onready var DOOR_OPEN = preload("res://sounds/sfx/DoorOpen.ogg")
@onready var FLIP_CARD = preload("res://sounds/sfx/FlipCard.ogg")
@onready var DIALOGUE_1 = preload("res://sounds/dialogue/Dialogue1.ogg")
@onready var DIALOGUE_2 = preload("res://sounds/dialogue/Dialogue2.ogg")
@onready var DIALOGUE_3 = preload("res://sounds/dialogue/Dialogue3.ogg")
#endregion



func change_music_stream(music) -> void:
	music_stream_player.stop()

	var stream = music 
	stream.loop = true
	music_stream_player.stream = stream
	music_stream_player.play()


func randomize_pitch_scale(audio_stream: AudioStreamPlayer) -> void:
	randomize()
	var pitch_scale = randf_range(0.75, 1.25)
	audio_stream.pitch_scale = pitch_scale


func stop_sfx() -> void:
	sfx_stream_player.stop()
