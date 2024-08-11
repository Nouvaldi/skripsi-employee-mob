import 'package:flutter/material.dart';

class MyDrawerTile extends StatelessWidget {
  final void Function()? onPressed;
  final Widget icon;
  final Widget label;

  const MyDrawerTile({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        style: ButtonStyle(
          backgroundColor:
              MaterialStatePropertyAll(Theme.of(context).colorScheme.tertiary),
          foregroundColor: MaterialStatePropertyAll(
              Theme.of(context).colorScheme.inversePrimary),
          alignment: Alignment.centerLeft,
          padding: const MaterialStatePropertyAll(EdgeInsets.all(16)),
        ),
        onPressed: onPressed,
        icon: icon,
        label: label,
      ),
    );
  }
}
