import 'package:flutter/material.dart';

class MyIconButton extends StatelessWidget {
  final void Function()? onPressed;
  final Widget icon;
  final String? tooltip;

  const MyIconButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      style: ButtonStyle(
        backgroundColor:
            MaterialStatePropertyAll(Theme.of(context).colorScheme.surface),
        foregroundColor:
            MaterialStatePropertyAll(Theme.of(context).colorScheme.tertiary),
        padding: const MaterialStatePropertyAll(EdgeInsets.all(24)),
      ),
      onPressed: onPressed,
      icon: icon,
      tooltip: tooltip,
    );
  }
}
