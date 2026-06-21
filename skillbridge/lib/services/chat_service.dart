import 'package:uuid/uuid.dart';
import '../models/message_model.dart';

/// Provides mock conversation/message data for the in-app chat feature.
///
/// In a production version this would be backed by a real-time backend
/// (e.g. Firebase Firestore streams or a WebSocket connection); the
/// [ChatProvider] is written against simple [Future]/in-memory calls so
/// swapping the implementation later does not require UI changes.
class ChatService {
  static const _uuid = Uuid();

  final List<ConversationModel> _conversations = [
    ConversationModel(
      id: 'c1',
      otherUserId: 'u2',
      otherUserName: 'Bilal Ahmed',
      relatedSkillTitle: 'Home Electrical Wiring & Repairs',
      lastMessage: 'Sure, I can come by tomorrow around 5 PM.',
      lastMessageTime: DateTime.now().subtract(const Duration(minutes: 12)),
      unread: true,
    ),
    ConversationModel(
      id: 'c2',
      otherUserId: 'u3',
      otherUserName: 'Sara Malik',
      relatedSkillTitle: 'O/A Level Mathematics Tutoring',
      lastMessage: 'Great, see you Saturday morning!',
      lastMessageTime: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    ConversationModel(
      id: 'c3',
      otherUserId: 'u1',
      otherUserName: 'Ayesha Khan',
      relatedSkillTitle: 'Custom Logo & Brand Design',
      lastMessage: 'I love the second concept, let\u2019s go with that.',
      lastMessageTime: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];

  final Map<String, List<MessageModel>> _messages = {
    'c1': [
      MessageModel(
        id: 'm1',
        conversationId: 'c1',
        senderId: 'u2',
        text: 'Hi! I saw your request about the wiring issue.',
        timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
      ),
      MessageModel(
        id: 'm2',
        conversationId: 'c1',
        senderId: 'me',
        text: 'Yes! My living room switchboard keeps tripping.',
        timestamp: DateTime.now().subtract(const Duration(minutes: 25)),
      ),
      MessageModel(
        id: 'm3',
        conversationId: 'c1',
        senderId: 'u2',
        text: 'Sure, I can come by tomorrow around 5 PM.',
        timestamp: DateTime.now().subtract(const Duration(minutes: 12)),
      ),
    ],
    'c2': [
      MessageModel(
        id: 'm4',
        conversationId: 'c2',
        senderId: 'u3',
        text: 'Hi, are you still looking for a math tutor?',
        timestamp: DateTime.now().subtract(const Duration(hours: 6)),
      ),
      MessageModel(
        id: 'm5',
        conversationId: 'c2',
        senderId: 'me',
        text: 'Yes please, weekends work best for me.',
        timestamp: DateTime.now().subtract(const Duration(hours: 5, minutes: 30)),
      ),
      MessageModel(
        id: 'm6',
        conversationId: 'c2',
        senderId: 'u3',
        text: 'Great, see you Saturday morning!',
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      ),
    ],
    'c3': [
      MessageModel(
        id: 'm7',
        conversationId: 'c3',
        senderId: 'me',
        text: 'Here are two logo concepts for your shop!',
        timestamp: DateTime.now().subtract(const Duration(days: 2, hours: 1)),
      ),
      MessageModel(
        id: 'm8',
        conversationId: 'c3',
        senderId: 'u1',
        text: 'I love the second concept, let\u2019s go with that.',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ],
  };

  Future<List<ConversationModel>> getConversations() async {
    final list = [..._conversations];
    list.sort((a, b) => b.lastMessageTime.compareTo(a.lastMessageTime));
    return list;
  }

  Future<List<MessageModel>> getMessages(String conversationId) async {
    return [...(_messages[conversationId] ?? [])];
  }

  Future<MessageModel> sendMessage(String conversationId, String text) async {
    final message = MessageModel(
      id: _uuid.v4(),
      conversationId: conversationId,
      senderId: 'me',
      text: text,
    );
    _messages.putIfAbsent(conversationId, () => []).add(message);

    final convo = _conversations.firstWhere((c) => c.id == conversationId);
    convo.lastMessage = text;
    convo.lastMessageTime = message.timestamp;

    return message;
  }

  /// Starts (or reuses) a conversation tied to a skill listing request,
  /// used by the "Request This Skill" button on the detail screen.
  Future<ConversationModel> startConversation({
    required String otherUserId,
    required String otherUserName,
    required String relatedSkillTitle,
  }) async {
    final existing = _conversations.where((c) => c.otherUserId == otherUserId);
    if (existing.isNotEmpty) return existing.first;

    final convo = ConversationModel(
      id: _uuid.v4(),
      otherUserId: otherUserId,
      otherUserName: otherUserName,
      relatedSkillTitle: relatedSkillTitle,
      lastMessage: 'Hi! I\u2019m interested in your listing.',
    );
    _conversations.add(convo);
    _messages[convo.id] = [
      MessageModel(
        id: _uuid.v4(),
        conversationId: convo.id,
        senderId: 'me',
        text: 'Hi! I\u2019m interested in your listing.',
      ),
    ];
    return convo;
  }
}
