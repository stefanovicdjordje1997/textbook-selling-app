import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final CrossAxisAlignment alignment;
  final double spacing;

  const CustomCard({
    super.key,
    required this.title,
    required this.children,
    this.alignment = CrossAxisAlignment.center,
    this.spacing = 10.0,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: alignment,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ...List.generate(children.length, (index) {
              return Column(
                children: [
                  children[index],
                  if (index < children.length - 1) SizedBox(height: spacing),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}
