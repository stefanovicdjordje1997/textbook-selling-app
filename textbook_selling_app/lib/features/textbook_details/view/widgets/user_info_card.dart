import 'package:flutter/material.dart';
import 'package:textbook_selling_app/core/models/user.dart';

class UserInfoCard extends StatelessWidget {
  const UserInfoCard({super.key, required this.user});

  final User user;

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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${user.firstName} ${user.lastName}",
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(user.phoneNumber,
                      style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
