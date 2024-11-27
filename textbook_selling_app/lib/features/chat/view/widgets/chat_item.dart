import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:textbook_selling_app/core/constants/local_keys.dart';
import 'package:textbook_selling_app/core/localization/app_localizations.dart';
import 'package:textbook_selling_app/core/models/chat.dart';
import 'package:textbook_selling_app/core/models/user.dart';
import 'package:textbook_selling_app/core/services/user_service.dart';
import 'package:textbook_selling_app/features/chat/viewmodel/chat_viewmodel.dart';

class ChatItem extends ConsumerWidget {
  const ChatItem({
    super.key,
    required this.chat,
    required this.onTap,
  });

  final Chat chat;
  final Function(User recipient) onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipientAsync = ref.watch(recipientProvider(chat));
    final lastMessageTime =
        ref.watch(chatProvider.notifier).formatTimestamp(chat.lastMessageTime!);

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300), // Trajanje animacije
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: child,
      ),
      child: recipientAsync.when(
        data: (recipient) {
          if (recipient == null) {
            return ListTile(
              key: const ValueKey('unknownUser'),
              title: Text(AppLocalizations.getString(LocalKeys.unknownUser)),
              subtitle: Text(AppLocalizations.getString(LocalKeys.noMessages)),
            );
          }

          return ListTile(
            key: ValueKey('recipient-${recipient.id}'),
            onTap: () => onTap(recipient),
            leading: CircleAvatar(
              radius: 24,
              backgroundColor:
                  Theme.of(context).colorScheme.primary.withOpacity(0.2),
              backgroundImage: recipient.profilePhoto != null &&
                      recipient.profilePhoto!.isNotEmpty
                  ? NetworkImage(recipient.profilePhoto!)
                  : null,
              child: recipient.profilePhoto == null ||
                      recipient.profilePhoto!.isEmpty
                  ? Icon(
                      Icons.person_rounded,
                      color: Theme.of(context).colorScheme.primary,
                    )
                  : null,
            ),
            title: Text(
              "${recipient.firstName} ${recipient.lastName}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              chat.lastMessage ??
                  AppLocalizations.getString(LocalKeys.noMessages),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.7)),
            ),
            trailing: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  chat.lastMessageTime != null ? lastMessageTime : "",
                  style: TextStyle(
                      color: chat.unreadCount[UserService.getUserId()]! > 0
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.7),
                      fontSize: 12),
                ),
                const SizedBox(height: 5),
                if (chat.unreadCount[UserService.getUserId()]! > 0)
                  CircleAvatar(
                    radius: 10,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: Text(
                      '${chat.unreadCount[UserService.getUserId()]}',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: 10),
                    ),
                  ),
              ],
            ),
          );
        },
        loading: () => null,
        error: (error, _) => ListTile(
          key: const ValueKey('error'),
          title: Text("Error: $error"),
        ),
      ),
    );
  }
}
