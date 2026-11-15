class NotificationPayload {
  final String packageName;
  final String title;
  final String text;
  final String subText;
  final int postTime;
  final String key;

  const NotificationPayload({
    required this.packageName,
    required this.title,
    required this.text,
    this.subText = '',
    required this.postTime,
    required this.key,
  });

  factory NotificationPayload.fromMap(Map<dynamic, dynamic> map) {
    return NotificationPayload(
      packageName: map['packageName'] as String? ?? '',
      title: map['title'] as String? ?? '',
      text: map['text'] as String? ?? '',
      subText: map['subText'] as String? ?? '',
      postTime: map['postTime'] as int? ?? DateTime.now().millisecondsSinceEpoch,
      key: map['key'] as String? ?? '',
    );
  }

  String get fullContent => '$title $text $subText'.trim();
}
