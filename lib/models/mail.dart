import 'dart:convert';

class MailMessage {
  final String subject;
  final String from;
  bool opened;
  final String body;
  final String date;
  String extras;
  MailMessage(
      {this.subject,
      this.from,
      this.body,
      this.extras,
      this.date,
      this.opened});

  MailMessage copyWith({
    String topic,
    String from,
    String body,
    String extras,
  }) {
    return MailMessage(
      from: from ?? this.from,
      body: body ?? this.body,
      extras: extras ?? this.extras,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'from': from,
      'body': body,
      'extras': extras,
    };
  }

  factory MailMessage.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return MailMessage(
      from: map['from'],
      body: map['body'],
      extras: map['extras'],
    );
  }

  String toJson() => json.encode(toMap());

  factory MailMessage.fromJson(String source) =>
      MailMessage.fromMap(json.decode(source));

  @override
  String toString() {
    return 'MailMessage( from: $from, body: $body, extras: $extras)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is MailMessage &&
        o.from == from &&
        o.body == body &&
        o.extras == extras;
  }

  @override
  int get hashCode {
    return from.hashCode ^ body.hashCode ^ extras.hashCode;
  }
}
