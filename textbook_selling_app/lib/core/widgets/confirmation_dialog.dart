import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  const ConfirmationDialog({
    required this.title,
    required this.message,
    required this.onConfirm,
    Key? key,
  }) : super(key: key);

  final String title;
  final String message;
  final Function onConfirm;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Zaobljeni uglovi dijaloga
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ikona upozorenja
            const Icon(
              Icons.warning_amber_outlined,
              color: Colors.orangeAccent,
              size: 40,
            ),
            const SizedBox(height: 16),

            // Naslov
            Text(
              title,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),

            // Poruka
            Text(
              message,
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 24),

            // Akcioni dugmadi
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Otkazi dugme
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Zatvori dijalog bez akcije
                  },
                  child: Text('Cancel',
                      style: Theme.of(context).textTheme.bodyLarge),
                ),
                const SizedBox(width: 8),
                // Potvrdi dugme
                ElevatedButton(
                  onPressed: () {
                    onConfirm(); // Poziva funkciju za potvrdu
                    Navigator.of(context).pop(); // Zatvori dijalog
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Confirm',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(color: Theme.of(context).colorScheme.error),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
