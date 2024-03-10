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
  });

  final String text;
  final ItemSpanType type;

  factory ItemSpan.fromMap(Map<String, dynamic> map) {
    return ItemSpan(
      text: map['text'] as String,
      type: ItemSpanType.fromName(map['type'] as String),
    );
  }

  @override
  String toString() => 'ItemSpan(text: $text, type: $type)';

  @override
  bool operator ==(covariant ItemSpan other) {
    if (identical(this, other)) return true;

    return other.text == text && other.type == type;
  }

  @override
  int get hashCode => text.hashCode ^ type.hashCode;
}
