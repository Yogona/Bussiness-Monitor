import 'package:flutter/material.dart';

class DefaultPage extends StatelessWidget {
  final String text;
  DefaultPage({required this.text});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text(
        this.text,
      ),
    );
  }
}
