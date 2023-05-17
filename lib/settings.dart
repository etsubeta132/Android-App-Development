import 'package:flutter/material.dart';
import 'package:my_time/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
        ),
        body: const Settings());
  }
}

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  TextEditingController txtWork = TextEditingController();
  TextEditingController txtShort = TextEditingController();
  TextEditingController txtLong = TextEditingController();

  static const String WORKTIME = "workTime";
  static const String SHORTBREAK = "shortBreak";
  static const String LONGBREAK = "longBreak";
  int workTime = 0;
  int shortBreak = 0;
  int longBreak = 0;

  late SharedPreferences prefs;

  @override
  void initState() {
    TextEditingController txtWork = TextEditingController();
    TextEditingController txtShort = TextEditingController();
    TextEditingController txtLong = TextEditingController();
    readSettings();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(fontSize: 24);
    return Scaffold(
        body: GridView.count(
      scrollDirection: Axis.vertical,
      crossAxisCount: 3,
      childAspectRatio: 3,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      padding: const EdgeInsets.all(20.0),
      children: <Widget>[
        const Text("Work", style: textStyle),
        const Text(""),
        const Text(""),
        SettingsButton(Color(0xff455A64), "-", -1, WORKTIME, updateSetting),
        TextField(
            style: textStyle,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            controller: txtWork),
        SettingsButton(
            const Color(0xff009688), "+", 1, WORKTIME, updateSetting),
        const Text("Short", style: textStyle),
        const Text(""),
        const Text(""),
        SettingsButton(Color(0xff455A64), "-", -1, SHORTBREAK, updateSetting),
        TextField(
          style: textStyle,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          controller: txtShort,
        ),
        SettingsButton(Color(0xff009688), "+", 1, SHORTBREAK, updateSetting),
        const Text("Long", style: textStyle),
        const Text(""),
        const Text(""),
        SettingsButton(Color(0xff455A64), "-", -1, LONGBREAK, updateSetting),
        TextField(
          style: textStyle,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          controller: txtLong,
        ),
        SettingsButton(Color(0xff009688), "+", 1, LONGBREAK, updateSetting),
      ],
    ));
  }

  readSettings() async {
    prefs = await SharedPreferences.getInstance();
    int? workTime = prefs.getInt(WORKTIME);
    if (workTime == null) {
      await prefs.setInt(WORKTIME, int.parse('30'));
    }
    int? shortBreak = prefs.getInt(SHORTBREAK);
    if (shortBreak == null) {
      await prefs.setInt(SHORTBREAK, int.parse('5'));
    }
    int? longBreak = prefs.getInt(LONGBREAK);
    if (longBreak == null) {
      await prefs.setInt(LONGBREAK, int.parse('20'));
    }
    setState(() {
      txtWork.text = workTime.toString();
      txtShort.text = shortBreak.toString();
      txtLong.text = longBreak.toString();
    });
  }

  void updateSetting(String key, int value) {
    switch (key) {
      case WORKTIME:
        {
          int? workTime = prefs.getInt(WORKTIME)!;
          workTime += value;
          if (workTime >= 1 && workTime <= 180) {
            prefs.setInt(WORKTIME, workTime);
            setState(() {
              txtWork.text = workTime.toString();
            });
          }
        }
        break;
      case SHORTBREAK:
        {
          int short = prefs.getInt(SHORTBREAK)!;
          short += value;
          if (short >= 1 && short <= 120) {
            prefs.setInt(SHORTBREAK, short);
            setState(() {
              txtShort.text = short.toString();
            });
          }
        }
        break;
      case LONGBREAK:
        {
          int long = prefs.getInt(LONGBREAK)!;
          long += value;
          if (long >= 1 && long <= 180) {
            prefs.setInt(LONGBREAK, long);
            setState(() {
              txtLong.text = long.toString();
            });
          }
        }
        break;
    }
  }
}
