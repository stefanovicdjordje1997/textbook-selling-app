import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:textbook_selling_app/core/models/user.dart';
import 'package:textbook_selling_app/features/chat/view/widgets/chat_app_bar.dart';
import 'package:textbook_selling_app/features/chat/view/widgets/message_input.dart';
import 'package:textbook_selling_app/features/chat/view/widgets/message_list.dart';
import 'package:textbook_selling_app/features/chat/viewmodel/chat_viewmodel.dart';

class SingleChatScreen extends ConsumerStatefulWidget {
  const SingleChatScreen({
    super.key,
    required this.recipient,
  });

  final User recipient;

  @override
  ConsumerState<SingleChatScreen> createState() => _SingleChatScreenState();
}

class _SingleChatScreenState extends ConsumerState<SingleChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    final viewModel = ref.read(chatProvider.notifier);
    viewModel.createChat(widget.recipient.id);
    viewModel.initializeStream(widget.recipient.id);
    viewModel.markMessagesAsRead(widget.recipient.id);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom(offset: 20);
    });
  }

  @override
  void deactivate() {
    final viewModel = ref.read(chatProvider.notifier);
    viewModel.markMessagesAsRead(widget.recipient.id);
    super.deactivate();
  }

  void _scrollToBottom({offset = 0}) {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.minScrollExtent + offset,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatProvider);
    final viewModel = ref.watch(chatProvider.notifier);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (chatState.messages.isNotEmpty) {
        _scrollToBottom();
      }
    });

    return Scaffold(
      appBar: ChatAppBar(recipient: widget.recipient),
      body: Column(
        children: [
          Expanded(
            child: MessageList(
              messages: chatState.messages,
              viewModel: viewModel,
              scrollController: _scrollController,
            ),
          ),
          MessageInput(
            controller: _messageController,
            onSend: (text) {
              viewModel.sendMessage(
                recipientId: widget.recipient.id,
                text: text,
              );
              _scrollToBottom();
            },
          ),
        ],
      ),
    );
  }
}
