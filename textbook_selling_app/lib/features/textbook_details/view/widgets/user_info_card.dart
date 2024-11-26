import 'package:flutter/material.dart';
import 'package:textbook_selling_app/core/models/user.dart';
import 'package:textbook_selling_app/core/navigation/create_route.dart';
import 'package:textbook_selling_app/features/chat/view/screens/single_chat.dart';

class UserInfoCard extends StatelessWidget {
  const UserInfoCard({
    super.key,
    required this.user,
    required this.showChatButton,
  });

  final User user;
  final bool showChatButton;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      color: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Left: Profile photo
            CircleAvatar(
              radius: 40,
              backgroundColor:
                  Theme.of(context).colorScheme.primary.withOpacity(0.2),
              backgroundImage:
                  user.profilePhoto != null && user.profilePhoto!.isNotEmpty
                      ? NetworkImage(user.profilePhoto!)
                      : null,
              child: user.profilePhoto == null || user.profilePhoto!.isEmpty
                  ? Icon(Icons.person_rounded,
                      size: 40, color: Theme.of(context).colorScheme.primary)
                  : null,
            ),
            const SizedBox(width: 16),
            // Middle: Name and phone number
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${user.firstName} ${user.lastName}",
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.phoneNumber,
                    style: Theme.of(context).textTheme.bodyMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            // Right: Chat button (conditionally visible)
            if (showChatButton)
              IconButton(
                icon: Icon(
                  Icons.chat_rounded,
                  color: Theme.of(context).colorScheme.primary,
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    createRoute(
                        page: SingleChatScreen(recipient: user),
                        animationType: RouteAnimationType.slideFromRight),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
