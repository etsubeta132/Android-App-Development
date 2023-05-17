import 'package:flutter/material.dart';
import 'package:my_time/timerModel.dart';
import 'package:my_time/widgets.dart';
import 'package:percent_indicator/percent_indicator.dart';
import './timer.dart';
import 'settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const MyApp());

const double defaultPadding = 5.0;
final CountDownTimer timer = CountDownTimer();

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    timer.startWork();
    return MaterialApp(
        title: "My Work Timer",
        theme: ThemeData(primarySwatch: Colors.grey),
        home: const TimerHomePage());
  }
}

// void emptyMethod() {}
void goToSettings(BuildContext context) {
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => const SettingsScreen())
    );
}

class TimerHomePage extends StatelessWidget {
  const TimerHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<PopupMenuItem<String>> menuItems = <PopupMenuItem<String>>[];
    menuItems.add(const PopupMenuItem(
      value: "Settings",
      child: Text("Settings"),
    ));
    return Scaffold(
        appBar: AppBar(
          title: const Text("My Work Timer"),
          actions: [
            PopupMenuButton<String>(itemBuilder: (BuildContext context) {
              return menuItems.toList();
            }, onSelected: (s) {
              if (s == 'Settings') {
                goToSettings(context);
              }
            })
          ],
        ),
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final double availableWidth = constraints.maxWidth;
            return Column(
              children: [
                Row(
                  children: [
                    const Padding(padding: EdgeInsets.all(defaultPadding)),
                    Expanded(
                      child: ProductivityButton(
                      color: const Color(0xff009688),
                      onPressed: () => timer.startWork(),
                      text: "Work",
                      size: 150,
                    )),
                    const Padding(padding: EdgeInsets.all(defaultPadding)),
                    Expanded(
                        child: ProductivityButton(
                      color: const Color(0xff607D8B),
                      onPressed: () => timer.startBreak(true),
                      text: "Short Break",
                      size: 150,
                    )),
                    const Padding(padding: EdgeInsets.all(defaultPadding)),
                    Expanded(
                      child: ProductivityButton(
                      color: const Color(0xff455A64),
                      onPressed: () => timer.startBreak(false),
                      text: "Long Break",
                      size: 150,
                    )),
                  ],
                ),
                const Spacer(),
                Center(
                    child: StreamBuilder(
                        initialData: "00:00",
                        stream: timer.stream(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          TimerModel timer = (snapshot.data == '00:00')
                              ? TimerModel("00:00", 1)
                              : snapshot.data;
                          return CircularPercentIndicator(
                              radius: availableWidth / 4,
                              lineWidth: 10.0,
                              percent: timer.percent,
                              center: Text(timer.time,
                                  style: Theme.of(context).textTheme.headline4),
                              progressColor: const Color(0xff009688));
                        })),
                const Spacer(),
                Row(children: [
                  const Padding(padding: EdgeInsets.all(defaultPadding)),
                  Expanded(
                      child: ProductivityButton(
                    color: const Color(0xff212121),
                    onPressed: () => timer.stopTimer(),
                    text: "Stop",
                    size: 150,
                  )),
                  const Padding(padding: EdgeInsets.all(defaultPadding)),
                  Expanded(
                    child: ProductivityButton(
                    color: const Color(0xff009688),
                    onPressed: () => timer.startTimer(),
                    text: "Start",
                    size: 150,
                  )),
                ]),
              ],
            );
          },
        ));
  }
}
