import 'package:flutter/material.dart';

class MyElevatedButton extends StatelessWidget {
  final void Function()? onPressed;
  final Widget icon;
  final Widget label;

  const MyElevatedButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ButtonStyle(
        backgroundColor:
            MaterialStatePropertyAll(Theme.of(context).colorScheme.surface),
        foregroundColor: MaterialStatePropertyAll(
            Theme.of(context).colorScheme.tertiary),
        padding: const MaterialStatePropertyAll(EdgeInsets.all(16)),
        enableFeedback: true,
      ),
      onPressed: onPressed,
      icon: icon,
      label: label,
    );
  }
}
