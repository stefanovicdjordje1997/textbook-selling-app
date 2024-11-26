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
            backgroundImage: recipient.profilePhoto != null
                ? NetworkImage(recipient.profilePhoto!)
                : null,
            child: recipient.profilePhoto == null
                ? const Icon(Icons.person)
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
