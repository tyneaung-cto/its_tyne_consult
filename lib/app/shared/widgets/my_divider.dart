import 'package:flutter/material.dart';

class MyDivider extends StatefulWidget {
  const MyDivider({super.key});

  @override
  State<MyDivider> createState() => _MyDividerState();
}

class _MyDividerState extends State<MyDivider> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Divider(),
    );
  }
}
