import 'package:flutter/material.dart';

class CustomSwitch extends StatelessWidget {
  const CustomSwitch({
    super.key,
    required this.labelText,
    required this.value,
    required this.onChanged,
  });

  final String labelText;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onChanged(!value);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        height: 75,
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: value
              ? Theme.of(context).colorScheme.secondary.withOpacity(0.2)
              : Colors.transparent,
          border: Border.all(
            color: value
                ? Theme.of(context).colorScheme.secondary
                : Theme.of(context).colorScheme.outline,
            width: 3,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                labelText,
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.left,
              ),
            ),
            Switch(
              value: value,
              onChanged: (newValue) {
                onChanged(newValue);
              },
            ),
          ],
        ),
      ),
    );
  }
}
