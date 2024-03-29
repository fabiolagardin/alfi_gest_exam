import 'package:flutter/material.dart';

class StandardButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  final double? paddingHorizontal;
  final double? paddingVertical;

  const StandardButton({
    Key? key,
    required this.onPressed,
    required this.child,
    this.paddingHorizontal,
    this.paddingVertical,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(
            horizontal: paddingHorizontal ?? 50,
            vertical: paddingVertical ?? 10),
        backgroundColor: Theme.of(context).colorScheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
      ),
      child: child,
    );
  }
}
