import 'package:messenger/models/message_model.dart';

class GroupMessagesUtil {
  static int TIME_BETWEEN = 15;

  static List<GroupedMessages> group(List<MessageModel> messages) {
    messages.sort((a, b) => int.parse(a.sent).compareTo(int.parse(b.sent)));

    List<GroupedMessages> groupedMessages = [];
    List<MessageModel> currentGroup = [];

    for (int i = 0; i < messages.length; i++) {
      MessageModel currentMessage = messages[i];

      if (currentGroup.isEmpty || shouldGroup(currentGroup.last, currentMessage)) {
        currentGroup.add(currentMessage);
      } else {
        groupedMessages.add(GroupedMessages(
          time: currentGroup.first.sent,
          messages: List.from(currentGroup),
        ));
        currentGroup = [currentMessage];
      }
    }

    if (currentGroup.isNotEmpty) {
      groupedMessages.add(GroupedMessages(
        time: currentGroup.first.sent,
        messages: List.from(currentGroup),
      ));
    }

    return groupedMessages;
  }

  static List<String> historyTime(List<MessageModel> messages) {
    List<GroupedMessages> groupedMessages = group(messages);
    List<String> historyTime = [groupedMessages[0].time];

    for (int i = 0; i < groupedMessages.length - 1; i++) {
      DateTime currentGroupTime = DateTime.fromMillisecondsSinceEpoch(int.parse(groupedMessages[i].time));
      DateTime nextGroupTime = DateTime.fromMillisecondsSinceEpoch(int.parse(groupedMessages[i + 1].time));

      if (nextGroupTime.difference(currentGroupTime).inMinutes > TIME_BETWEEN) historyTime.add(groupedMessages[i + 1].time);
    }

    return historyTime;
  }

  static bool shouldGroup(MessageModel previousMessage, MessageModel currentMessage) {
    if (previousMessage == null) return true;

    DateTime currentMessageTime = DateTime.fromMillisecondsSinceEpoch(int.parse(currentMessage.sent));
    DateTime previousMessageTime = DateTime.fromMillisecondsSinceEpoch(int.parse(previousMessage.sent));

    return currentMessageTime.difference(previousMessageTime).inMinutes <= TIME_BETWEEN && currentMessage.fromId == previousMessage.fromId;
  }
}
