import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_sound_lite/public/flutter_sound_player.dart';
import 'package:flutter_sound_lite/public/flutter_sound_recorder.dart';
import 'package:permission_handler/permission_handler.dart';

class SoundController extends ChangeNotifier {
  static final SoundController _instance = SoundController._internal();
  static SoundController get instance => _instance;
  SoundController._internal();

  FlutterSoundRecorder? _audioRecorder;
  Duration _recordDuration = Duration.zero;
  Timer? _timer;
  bool _isRecorderInitialised = false;

  FlutterSoundPlayer? _audioPlayer;
  bool _isPlaying = false;

  Duration get recordDuration => _recordDuration;
  bool get isPlaying => _isPlaying;
  bool get isRecording => _audioRecorder?.isRecording ?? false;

  String get audioTime {
    int minutes = _recordDuration.inMinutes.remainder(60);
    int seconds = _recordDuration.inSeconds.remainder(60);
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  Future<void> initAudio() async {
    _audioRecorder = FlutterSoundRecorder();
    _audioPlayer = FlutterSoundPlayer();
    _audioPlayer!.setSubscriptionDuration(const Duration(milliseconds: 100));

    final status = await Permission.microphone.status;
    if (status == PermissionStatus.granted) {
      try {
        await _audioRecorder!.openAudioSession();
        _isRecorderInitialised = true;
      } catch (e) {
        print('Error opening audio session: $e');
      }
    } else {
      throw RecordingPermissionException('Microphone permission not granted');
    }

    notifyListeners();
  }

  Future<void> disposeAudio() async {
    await _audioRecorder!.closeAudioSession();
    _audioRecorder = null;
    _isRecorderInitialised = false;
    notifyListeners();
  }

  Future<void> recordAudio() async {
    if (_isRecorderInitialised) {
      try {
        _startTimer();
        await _audioRecorder!.startRecorder(
          toFile: '${DateTime.now().millisecondsSinceEpoch.toString()}.aac',
        );
        notifyListeners();
      } catch (e) {
        _stopTimer();
        print(e.toString());
      }
    }
  }

  Future<String?> stopAudio() async {
    if (_isRecorderInitialised) {
      try {
        _stopTimer();
        String? res = await _audioRecorder!.stopRecorder();
        notifyListeners();
        return res;
      } catch (e) {
        _stopTimer();
        print('Error stopping recorder: $e');
      }
    }
    return null;
  }

  Future<void> toggleAudio() async {
    if (_audioRecorder!.isStopped) {
      await recordAudio();
    } else {
      await stopAudio();
    }
  }

  Future<void> playSound(String audioUrl) async {
    if (_audioPlayer != null) {
      if (!_audioPlayer!.isPlaying) {
        await _audioPlayer!.openAudioSession();
        _audioPlayer!.onProgress!.listen((progress) {
          if (progress.duration == progress.position) {
            _isPlaying = false;
            notifyListeners();
          }
        });
      }

      await _audioPlayer!.startPlayer(fromURI: audioUrl);

      _isPlaying = true;
      notifyListeners();
    }
  }

  Future<void> stopSound() async {
    if (_audioPlayer != null) {
      await _audioPlayer!.stopPlayer();
      _isPlaying = false;
      notifyListeners();
    }
  }

  Future<void> pauseSound() async {
    await _audioPlayer!.pausePlayer();
    _isPlaying = false;
    notifyListeners();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _recordDuration += const Duration(seconds: 1);

      notifyListeners();
    });
  }

  void _stopTimer({bool resetTime = true}) {
    _timer?.cancel();
    _timer = null;

    if (resetTime) {
      _recordDuration = Duration.zero;
      notifyListeners();
    }
  }
}
