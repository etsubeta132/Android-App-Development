import 'dart:async';
import './timerModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CountDownTimer {
  double _radius = 1;
  bool _isActive = true;
  late Timer timer;
  Duration _time = const Duration(seconds: 1);
  late Duration _fullTime;
  int work = 30;
  int shortBreak = 5;
  int longBreak = 20;
  CountDownTimer();

  get percent => _radius;
  get time => _time;

  Future readSettings() async {
    SharedPreferences prefs = await
    SharedPreferences.getInstance();
    work = (prefs.getInt('workTime') ?? 30);
    shortBreak = (prefs.getInt('shortBreak') ?? 5);
    longBreak = (prefs.getInt('longBreak') ?? 20);
  }

  String returnTimer(Duration t) {
    String minutes =
        (t.inMinutes < 10) ? "0${t.inMinutes}" : t.inMinutes.toString();
    int numSeconds = t.inSeconds - (t.inMinutes * 60);
    String seconds = (numSeconds < 10) ? "0$numSeconds" : numSeconds.toString();
    String formattedTime = "$minutes : $seconds";
    return formattedTime;
  }

  Stream<TimerModel> stream() async* {
    yield* Stream.periodic(Duration(seconds: 1), (int a) {
      String time;
      if (_isActive) {
        _time = _time - Duration(seconds: 1);
        _radius = _time.inSeconds / _fullTime.inSeconds;
        if (_time.inSeconds <= 0) {
          _isActive = false;
        }
      }
      time = returnTimer(_time);
      return TimerModel(time, _radius);
    });
  }

  void startWork() async {
    await readSettings();
    _radius = 1;
    _time = Duration(minutes: this.work, seconds: 0);
    _fullTime = _time;
  }

  void startTimer() {
    if (_time.inSeconds > 0) {
      this._isActive = true;
    }
  }

  void stopTimer() {
    this._isActive = false;
  }

  Future<void> startBreak(bool isShort) async {
    await readSettings();
    _radius = 1;
    _time = Duration(minutes: (isShort) ? shortBreak : longBreak, seconds: 0);
    _fullTime = _time;
  }
}
