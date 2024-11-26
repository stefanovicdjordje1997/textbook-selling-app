import 'package:flutter/material.dart';
import 'package:textbook_selling_app/core/models/message.dart';
import 'package:textbook_selling_app/features/chat/view/widgets/message_bubble.dart';
import 'package:textbook_selling_app/features/chat/viewmodel/chat_viewmodel.dart';

class MessageList extends StatelessWidget {
  const MessageList({
    super.key,
    required this.messages,
    required this.viewModel,
    required this.scrollController,
  });

  final List<Message> messages;
  final ChatViewModel viewModel;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    if (messages.isEmpty) {
      return const Center(child: Text("No messages yet."));
    }

    return ListView.builder(
      reverse: true, // Keeps the messages in reverse order
      padding: const EdgeInsets.only(bottom: 20),
      controller: scrollController,
      itemCount: messages.length,
      itemBuilder: (context, index) {
        // Access message from the "end" due to reverse: true
        final message = messages[messages.length - 1 - index];
        final isMe = message.senderId == viewModel.senderId;

        final previousMessageDate = index < messages.length - 1
            ? messages[messages.length - 2 - index].timestamp
            : null;
        final currentMessageDate = message.timestamp;

        final showDateHeader = previousMessageDate == null ||
            !viewModel.isSameDay(previousMessageDate, currentMessageDate);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showDateHeader)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Center(
                  child: Text(
                    viewModel.formatDateHeader(currentMessageDate),
                    style: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            MessageBubble(message: message, isMe: isMe),
          ],
        );
      },
    );
  }
}
