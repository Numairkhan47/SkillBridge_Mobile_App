import 'package:flutter/material.dart';
import '../models/message_model.dart';
import '../services/chat_service.dart';

class ChatProvider extends ChangeNotifier {
  final ChatService _chatService = ChatService();

  List<ConversationModel> _conversations = [];
  final Map<String, List<MessageModel>> _messagesCache = {};
  bool _isLoading = false;

  List<ConversationModel> get conversations => _conversations;
  bool get isLoading => _isLoading;

  int get unreadCount => _conversations.where((c) => c.unread).length;

  List<MessageModel> messagesFor(String conversationId) =>
      _messagesCache[conversationId] ?? [];

  Future<void> loadConversations() async {
    _isLoading = true;
    notifyListeners();
    _conversations = await _chatService.getConversations();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadMessages(String conversationId) async {
    final messages = await _chatService.getMessages(conversationId);
    _messagesCache[conversationId] = messages;
    final convo = _conversations.firstWhere((c) => c.id == conversationId);
    convo.unread = false;
    notifyListeners();
  }

  Future<void> sendMessage(String conversationId, String text) async {
    final message = await _chatService.sendMessage(conversationId, text);
    _messagesCache.putIfAbsent(conversationId, () => []).add(message);
    notifyListeners();
  }

  Future<ConversationModel> startConversation({
    required String otherUserId,
    required String otherUserName,
    required String relatedSkillTitle,
  }) async {
    final convo = await _chatService.startConversation(
      otherUserId: otherUserId,
      otherUserName: otherUserName,
      relatedSkillTitle: relatedSkillTitle,
    );
    await loadConversations();
    return convo;
  }
}
