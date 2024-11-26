import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:textbook_selling_app/core/models/chat.dart';
import 'package:textbook_selling_app/core/models/message.dart';
import 'package:textbook_selling_app/core/models/user.dart';
import 'package:textbook_selling_app/core/services/chat_service.dart';
import 'package:textbook_selling_app/core/services/user_service.dart';

class ChatViewModel extends StateNotifier<ChatState> {
  ChatViewModel() : super(ChatState());

  get senderId {
    return UserService.getUserId();
  }

  Future<void> createChat(String recipientId) async {
    try {
      await ChatService.createChatIfNotExists(
        userId1: senderId,
        userId2: recipientId,
      );
    } catch (error) {
      print("Error creating chat: $error");
    }
  }

  Future<User?> getRecipient(Chat chat) async {
    try {
      final recipientId =
          chat.userIds.firstWhere((userId) => userId != senderId);
      return await UserService.getUserById(recipientId);
    } catch (error) {
      print("Error fetching recipient: $error");
      return null;
    }
  }

  // Pokretanje stream-a za praćenje poruka
  void initializeStream(String userId2) {
    final messagesStream =
        ChatService.streamMessages(userId1: senderId, userId2: userId2);
    messagesStream.listen((messages) {
      state = state.copyWith(messages: messages);
    });
  }

  // Slanje poruke
  Future<void> sendMessage(
      {required String text, required String recipientId}) async {
    if (text.trim().isEmpty) return;

    state = state.copyWith(isLoading: true);

    final chatId = ChatService.generateChatId(senderId, recipientId);
    try {
      await ChatService.sendMessage(
        chatId: chatId,
        senderId: senderId,
        text: text.trim(),
      );
    } catch (error) {
      print("Error sending message: $error");
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  String formatTimestamp(DateTime timestamp) {
    final hours = timestamp.hour.toString().padLeft(2, '0');
    final minutes = timestamp.minute.toString().padLeft(2, '0');
    return '$hours:$minutes';
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  String formatDateHeader(DateTime date) {
    final now = DateTime.now();
    if (isSameDay(date, now)) {
      return "Today";
    } else if (isSameDay(date, now.subtract(const Duration(days: 1)))) {
      return "Yesterday";
    } else {
      return DateFormat('dd/MM/yy').format(date);
    }
  }
}

class ChatState {
  final List<Message> messages;

  ChatState({
    this.messages = const [],
  });

  ChatState copyWith({
    bool? isLoading,
    List<Message>? messages,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
    );
  }
}

final chatProvider = StateNotifierProvider<ChatViewModel, ChatState>(
  (ref) => ChatViewModel(),
);

final recipientProvider = FutureProvider.family<User?, Chat>(
  (ref, chat) {
    final chatViewModel = ref.read(chatProvider.notifier);
    return chatViewModel.getRecipient(chat);
  },
);
