import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:textbook_selling_app/core/models/chat.dart';
import 'package:textbook_selling_app/core/models/user.dart';
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

    return recipientAsync.when(
      data: (recipient) {
        if (recipient == null) {
          return const ListTile(
            title: Text("Unknown User"),
            subtitle: Text("No messages yet"),
          );
        }

        return ListTile(
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
            chat.lastMessage ?? "No messages yet",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.grey),
          ),
          trailing: Text(
            chat.lastMessageTime != null ? lastMessageTime : "",
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
        );
      },
      loading: () => const ListTile(
        title: Text("Loading..."),
      ),
      error: (error, _) => ListTile(
        title: Text("Error: $error"),
      ),
    );
  }
}
