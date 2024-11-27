import 'package:flutter/material.dart';

class LanguageSwitch extends StatelessWidget {
  const LanguageSwitch({
    super.key,
    required this.leftLanguage,
    required this.rightLanguage,
    required this.isLeftLanguageSelected,
    required this.onLanguageChange,
  });

  final String leftLanguage;
  final String rightLanguage;
  final bool isLeftLanguageSelected;
  final Future<void> Function(bool) onLanguageChange;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await onLanguageChange(!isLeftLanguageSelected);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isLeftLanguageSelected)
                    _buildSelectedLabel(leftLanguage, context),
                  if (!isLeftLanguageSelected)
                    _buildUnselectedLabel(leftLanguage, context),
                ],
              ),
            ),
            Switch(
              thumbIcon: WidgetStateProperty.all(
                Icon(
                  Icons.language_rounded,
                  size: 20,
                  color: Theme.of(context).colorScheme.surface,
                ),
              ),
              activeColor: Colors.red,
              inactiveThumbColor: Colors.blue,
              trackColor: WidgetStatePropertyAll(
                Theme.of(context).colorScheme.onSurface,
              ),
              trackOutlineColor: WidgetStatePropertyAll(
                Theme.of(context).colorScheme.primary,
              ),
              value: !isLeftLanguageSelected,
              onChanged: (value) async {
                await onLanguageChange(value);
              },
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isLeftLanguageSelected)
                    _buildUnselectedLabel(rightLanguage, context),
                  if (!isLeftLanguageSelected)
                    _buildSelectedLabel(rightLanguage, context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedLabel(String language, BuildContext context) {
    return Text(
      language,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Widget _buildUnselectedLabel(String language, BuildContext context) {
    return Text(
      language,
      style: TextStyle(
        fontSize: 16,
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }
}
