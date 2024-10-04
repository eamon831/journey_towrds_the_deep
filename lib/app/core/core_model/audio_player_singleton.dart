import 'package:just_audio/just_audio.dart';

class AudioPlayerSingleton {
  static final _instance = AudioPlayerSingleton._internal();

  factory AudioPlayerSingleton() {
    return _instance;
  }

  AudioPlayerSingleton._internal() {
    _init();
  }

  late AudioPlayer _audioPlayer; // For button presses
  late AudioPlayer _beepPlayer; // For double-tap beep
  late AudioSource _beepSoundSource;

  Future<void> _init() async {
    // Initialize audio players
    _audioPlayer = AudioPlayer();
    _beepPlayer = AudioPlayer();

    // Preload the sound files
    _beepSoundSource = AudioSource.asset('assets/audio/beep.mp3');

    // Pre-load audio so there’s no delay on play
    await _beepPlayer.setAudioSource(_beepSoundSource);
  }

  // Play the beep sound (for double-tap)
  Future<void> playBeepSound() async {
    await _beepPlayer.seek(Duration.zero); // Rewind to start
    await _beepPlayer.play();
  }

  // Example to pause the players if needed
  Future<void> pause() async {
    await _audioPlayer.pause();
    await _beepPlayer.pause();
  }

  // Stop both sounds
  Future<void> stop() async {
    await _audioPlayer.stop();
    await _beepPlayer.stop();
  }
}
