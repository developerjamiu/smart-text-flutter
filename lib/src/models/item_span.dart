enum ItemSpanType {
  address,
  phone,
  email,
  datetime,
  url,
  text;

  static ItemSpanType fromName(String name) {
    return ItemSpanType.values.firstWhere(
      (type) => type.name == name,
      orElse: () => ItemSpanType.text,
    );
  }
}

class ItemSpan {
  const ItemSpan({
    required this.text,
    required this.type,
    required this.rawValue,
  });

  final String text;
  final String rawValue;
  final ItemSpanType type;

  factory ItemSpan.fromMap(Map<String, dynamic> map) {
    return ItemSpan(
      text: map['text'] as String,
      rawValue: map['rawValue'] as String,
      type: ItemSpanType.fromName(map['type'] as String),
    );
  }

  @override
  String toString() =>
      'ItemSpan(text: $text, rawValue: $rawValue, type: $type)';

  @override
  bool operator ==(covariant ItemSpan other) {
    if (identical(this, other)) return true;

    return other.text == text &&
        other.type == type &&
        other.rawValue == rawValue;
  }

  @override
  int get hashCode => text.hashCode ^ type.hashCode;
}
