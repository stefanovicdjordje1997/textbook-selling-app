import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:textbook_selling_app/core/models/chat.dart';
import 'package:textbook_selling_app/core/navigation/create_route.dart';
import 'package:textbook_selling_app/features/chat/view/screens/single_chat.dart';
import 'package:textbook_selling_app/features/chat/view/widgets/chat_item.dart';
import 'package:textbook_selling_app/core/services/chat_service.dart';

class ChatsScreen extends ConsumerStatefulWidget {
  const ChatsScreen({super.key});

  @override
  ConsumerState<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends ConsumerState<ChatsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inbox'),
      ),
      body: StreamBuilder<List<Chat>>(
        stream: ChatService.streamUserChats(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No chats available."));
          }

          final chats = snapshot.data!;
          return ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              final chat = chats[index];
              return ChatItem(
                chat: chat,
                onTap: (recipient) {
                  Navigator.push(
                    context,
                    createRoute(
                      page: SingleChatScreen(recipient: recipient),
                      animationType: RouteAnimationType.slideFromRight,
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
