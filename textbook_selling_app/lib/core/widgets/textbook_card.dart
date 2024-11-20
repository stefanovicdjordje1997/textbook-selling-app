import 'package:flutter/material.dart';
import 'package:textbook_selling_app/core/models/textbook.dart';

class TextbookCard extends StatelessWidget {
  const TextbookCard({
    super.key,
    required this.textbook,
    required this.onTap,
    this.onRemove,
  });

  final Textbook textbook;
  final VoidCallback onTap;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.3),
        shadowColor: Theme.of(context).shadowColor.withOpacity(0.2),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image container or placeholder
              Container(
                height: 180,
                width: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).colorScheme.onPrimary,
                  image: textbook.imageUrls.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(textbook.imageUrls.first),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: textbook.imageUrls.isEmpty
                    ? const Icon(
                        Icons.image,
                        size: 60,
                        color: Colors.white54,
                      )
                    : null,
              ),
              const SizedBox(width: 16),

              // Book details
              Expanded(
                child: SizedBox(
                  height: 180,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Book name
                      Text(
                        textbook.name,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontWeight: FontWeight.w600,
                            ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),

                      // Institution
                      _buildInfoRow(
                        icon: Icons.account_balance_outlined,
                        value: textbook.institution,
                        context: context,
                      ),
                      const SizedBox(height: 12),

                      // Major
                      _buildInfoRow(
                        icon: Icons.school_outlined,
                        value: textbook.major,
                        context: context,
                      ),
                      const Spacer(),

                      // Price and optional remove button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${textbook.price.toStringAsFixed(2)} RSD",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          if (onRemove != null)
                            IconButton(
                              icon: Icon(
                                Icons.delete_outline,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              onPressed: () {
                                if (onRemove != null) {
                                  onRemove!();
                                }
                              },
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget for row item with an icon
  Widget _buildInfoRow({
    required IconData icon,
    required String value,
    required BuildContext context,
  }) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
