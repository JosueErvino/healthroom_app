import 'package:flutter/material.dart';

class CircularText extends StatelessWidget {
  const CircularText({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.0,
      height: 40.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(width: 2),
        color: Theme.of(context).colorScheme.secondary,
      ),
      child: Center(
        child: Text(
          text,
          style: Theme.of(context).textTheme.labelMedium,
        ),
      ),
    );
  }
}
