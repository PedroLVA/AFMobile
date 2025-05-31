import 'package:firebase_auth/firebase_auth.dart';

class AppUser {
  final String uid;
  final String email;
  final String? displayName;
  final String? phoneNumber;
  final DateTime? createdAt;

  AppUser({
    required this.uid,
    required this.email,
    this.displayName,
    this.phoneNumber,
    this.createdAt,
  });

  factory AppUser.fromFirebaseUser(User user, {String? phoneNumber}) {
    return AppUser(
      uid: user.uid,
      email: user.email ?? '',
      displayName: user.displayName,
      phoneNumber: phoneNumber,
      createdAt: user.metadata.creationTime,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'phoneNumber': phoneNumber,
      'createdAt': createdAt?.millisecondsSinceEpoch,

    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      displayName: map['displayName'],
      phoneNumber: map['phoneNumber'], //
      createdAt: map['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'])
          : null,

    );
  }
}