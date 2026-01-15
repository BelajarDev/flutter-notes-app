// note_model.dart
import 'package:flutter/material.dart';

class Note {
  String id;
  String title;
  String content;
  DateTime createdAt;
  DateTime updatedAt;
  bool isPinned;
  int colorIndex; // 0-6 untuk warna berbeda

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    this.isPinned = false,
    this.colorIndex = 0,
  });

  Note.create({required this.title, required this.content, this.colorIndex = 0})
    : id = DateTime.now().millisecondsSinceEpoch.toString(),
      createdAt = DateTime.now(),
      updatedAt = DateTime.now(),
      isPinned = false;

  // Method untuk mendapatkan warna berdasarkan index
  static List<Map<String, Color>> get colors => [
    {'primary': const Color(0xFFFFE8E8), 'accent': const Color(0xFFFF6B6B)},
    {'primary': const Color(0xFFE8F9FF), 'accent': const Color(0xFF4FC3F7)},
    {'primary': const Color(0xFFF3E8FF), 'accent': const Color(0xFFBA68C8)},
    {'primary': const Color(0xFFE8FFEA), 'accent': const Color(0xFF66BB6A)},
    {'primary': const Color(0xFFFFF8E8), 'accent': const Color(0xFFFFB74D)},
    {'primary': const Color(0xFFE8F4FF), 'accent': const Color(0xFF42A5F5)},
    {'primary': const Color(0xFFFFF0F5), 'accent': const Color(0xFFEC407A)},
  ];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isPinned': isPinned,
      'colorIndex': colorIndex,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      isPinned: map['isPinned'] ?? false,
      colorIndex: map['colorIndex'] ?? 0,
    );
  }

  Note copyWith({
    String? id,
    String? title,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isPinned,
    int? colorIndex,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isPinned: isPinned ?? this.isPinned,
      colorIndex: colorIndex ?? this.colorIndex,
    );
  }
}
