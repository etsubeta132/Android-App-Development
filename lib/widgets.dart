import 'package:flutter/material.dart';

typedef CallbackSetting = void Function(String, int);

class ProductivityButton extends StatelessWidget {
  final Color color;
  final String text;
  final double size;
  final VoidCallback onPressed;

  const ProductivityButton(
      {super.key,
      required this.color,
      required this.text,
      required this.onPressed,
      required this.size});
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      color: color,
      minWidth: size,
      child: Text(text, style: const TextStyle(color: Colors.white)),
    );
  }
}

class SettingsButton extends StatelessWidget {
  final Color color;
  final String text;
  final double size = 20;
  final int value;
  final String setting;
  final CallbackSetting callback;
  SettingsButton(this.color, this.text, this.value,this.setting,this.callback);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () => this.callback(this.setting,this.value),
      color: this.color,
      minWidth: this.size,
      child: Text(this.text, style: const TextStyle(color: Colors.white)),
    );
  }
}
