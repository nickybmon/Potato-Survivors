extends Node

# Persistent background music that survives scene transitions.
# Starts automatically on launch and loops forever.

const MUSIC_PATH := "res://resources/music/Mecha_Future_Looped.mp3"

var _player: AudioStreamPlayer


func _ready() -> void:
	_player = AudioStreamPlayer.new()
	_player.volume_db = -10.0
	add_child(_player)

	var stream := load(MUSIC_PATH)
	if stream is AudioStreamMP3:
		(stream as AudioStreamMP3).loop = true
	_player.stream = stream
	_player.play()


func stop() -> void:
	_player.stop()


func resume() -> void:
	if not _player.playing:
		_player.play()
