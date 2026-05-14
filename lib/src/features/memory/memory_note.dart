class MemoryNote {
  const MemoryNote({
    required this.id,
    required this.text,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String text;
  final DateTime createdAt;
  final DateTime updatedAt;

  MemoryNote copyWith({
    String? id,
    String? text,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MemoryNote(
      id: id ?? this.id,
      text: text ?? this.text,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  static MemoryNote fromMap(Map<dynamic, dynamic> map) {
    return MemoryNote(
      id: map['id'] as String,
      text: map['text'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
    );
  }
}
