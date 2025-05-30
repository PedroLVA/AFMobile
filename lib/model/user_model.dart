import 'package:firebase_auth/firebase_auth.dart';

class AppUser {
  final String uid;
  final String email;
  final String? displayName;
  final String? phoneNumber; // <-- ADDED phoneNumber
  final DateTime? createdAt;

  AppUser({
    required this.uid,
    required this.email,
    this.displayName,
    this.phoneNumber, // <-- ADDED phoneNumber to constructor
    this.createdAt,
  });

  factory AppUser.fromFirebaseUser(User user, {String? phoneNumber}) { // Optionally pass during conversion
    return AppUser(
      uid: user.uid,
      email: user.email ?? '',
      displayName: user.displayName,
      phoneNumber: phoneNumber, // <-- Use passed phoneNumber
      createdAt: user.metadata.creationTime,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'phoneNumber': phoneNumber, // <-- ADDED phoneNumber to map
      'createdAt': createdAt?.millisecondsSinceEpoch,
      // You can also store it as Timestamp:
      // 'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      displayName: map['displayName'],
      phoneNumber: map['phoneNumber'], // <-- ADDED phoneNumber from map
      createdAt: map['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'])
          : null,
      // If storing as Timestamp:
      // createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
    );
  }
}