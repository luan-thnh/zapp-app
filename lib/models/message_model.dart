class MessageModel {
  MessageModel({
    required this.read,
    required this.type,
    required this.message,
    required this.sent,
    required this.toId,
    required this.fromId,
    required this.duration,
  });

  late final String read;
  late final Type type;
  late final String message;
  late final String sent;
  late final String toId;
  late final String fromId;
  String duration = '${Duration.zero}';

  MessageModel.fromJson(Map<String, dynamic> json) {
    read = json['read'].toString();
    type = _parseMessageType(json['type']);
    message = json['message'].toString();
    sent = json['sent'].toString();
    toId = json['toId'].toString();
    fromId = json['fromId'].toString();
    if (json['duration'] != null && type == Type.audio) {
      duration = json['duration'].toString();
    }
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['read'] = read;
    _data['type'] = _typeToString(type);
    _data['message'] = message;
    _data['sent'] = sent;
    _data['toId'] = toId;
    _data['fromId'] = fromId;
    if (type == Type.audio) {
      _data['duration'] = duration;
    }
    return _data;
  }

  // Helper function to parse the 'Type' enum from a string
  Type _parseMessageType(String value) {
    switch (value) {
      case 'text':
        return Type.text;
      case 'image':
        return Type.image;
      case 'audio':
        return Type.audio;
      default:
        throw ArgumentError('Invalid value for MessageType: $value');
    }
  }

  // Helper function to convert the 'Type' enum to a string
  String _typeToString(Type type) {
    switch (type) {
      case Type.text:
        return 'text';
      case Type.image:
        return 'image';
      case Type.audio:
        return 'audio';
    }
  }
}

class GroupedMessages {
  late final String time;
  late final List<MessageModel> messages;

  GroupedMessages({required this.time, required this.messages});

  Map<String, dynamic> toJson() {
    return {
      'time': time,
      'messages': messages.map((message) => message.toJson()).toList(),
    };
  }

  factory GroupedMessages.fromJson(Map<String, dynamic> json) {
    return GroupedMessages(
      time: json['time'],
      messages: (json['messages'] as List<dynamic>).map((messageJson) => MessageModel.fromJson(messageJson)).toList(),
    );
  }
}

// Enum definition
enum Type { text, image, audio }
