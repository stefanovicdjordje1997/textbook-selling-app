import 'package:flutter/material.dart';
import 'package:textbook_selling_app/core/models/user.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ChatAppBar({
    super.key,
    required this.recipient,
  });

  final User recipient;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor:
                Theme.of(context).colorScheme.primary.withOpacity(0.2),
            backgroundImage: recipient.profilePhoto != null &&
                    recipient.profilePhoto!.isNotEmpty
                ? NetworkImage(recipient.profilePhoto!)
                : null,
            child: recipient.profilePhoto == null ||
                    recipient.profilePhoto!.isEmpty
                ? Icon(Icons.person_rounded,
                    color: Theme.of(context).colorScheme.primary)
                : null,
          ),
          const SizedBox(width: 8),
          Text("${recipient.firstName} ${recipient.lastName}"),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
