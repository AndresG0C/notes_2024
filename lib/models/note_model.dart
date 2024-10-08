import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  String id;
  String title;
  String content;
  DateTime date;
  String responsableId;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
    required this.responsableId,
  });

  
  factory Note.fromFirestore(Map<String, dynamic> data, String documentId) {
    return Note(
      id: documentId,
      title: data['title'],
      content: data['content'],
      date: (data['date'] as Timestamp).toDate(),
      responsableId: data['responsableId'],
    );
  }

  
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'date': date,
      'responsableId': responsableId,
    };
  }

  
  int daysSinceCreation() {
    final currentDate = DateTime.now();
    return currentDate.difference(date).inDays;
  }
}
