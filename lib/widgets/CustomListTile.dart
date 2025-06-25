import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomListTile extends StatelessWidget {
  final IconData iconData;
  final String title;
  final VoidCallback onTap;

  const CustomListTile({
    super.key,
    required this.iconData,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final color = isDark ? Colors.deepOrange : Colors.deepPurple;

    return ListTile(
      leading: FaIcon(
        iconData,
        color: color,
        size: 26,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,  // smaller font size
          color: color,
        ),
      ),
      
      trailing: Icon(
        Icons.keyboard_arrow_right,
        size: 16,
        color: color.withOpacity(0.6),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      shape: RoundedRectangleBorder(
        //borderRadius: BorderRadius.circular(12),
      ),
      onTap: onTap,
    );
  }
}
