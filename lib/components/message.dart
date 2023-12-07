import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Message {
  final String id;
  final String sentBy;
  final String messageText;
  final String sentAt;

  Message(
      {required this.id,
      required this.sentBy,
      required this.messageText,
      required this.sentAt});
}
