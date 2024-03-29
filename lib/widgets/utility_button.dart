import 'package:flutter/material.dart';

class UtilityButton extends StatelessWidget {
  final Widget icon;
  final VoidCallback onPressed;
  final bool? isSelected;

  const UtilityButton({
    Key? key,
    required this.icon,
    required this.onPressed,
    this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
     Color backgroundColor = isSelected ?? false
    ? Theme.of(context).colorScheme.inversePrimary
    : Theme.of(context).colorScheme.surfaceVariant;

    return InkWell(
      onTap: onPressed,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
              color: Theme.of(context).colorScheme.secondary, width: 0.5),
          //color: Theme.of(context).colorScheme.surfaceVariant,
          color: backgroundColor,
        ),
        child: Center(child: icon),
      ),
    );
  }
}
