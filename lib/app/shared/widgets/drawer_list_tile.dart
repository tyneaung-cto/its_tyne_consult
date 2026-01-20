import 'package:flutter/material.dart';

class DrawerListTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final TextStyle? textStyle;
  final bool? isIconRed;

  const DrawerListTile({super.key, required this.title, required this.icon, required this.onTap, this.textStyle, this.isIconRed = false});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: isIconRed == true ? Colors.red : null,
      ),
      title: Text(title, style: textStyle),
      onTap: onTap,
    );
  }
}