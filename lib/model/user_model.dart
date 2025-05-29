import 'package:firebase_auth/firebase_auth.dart'; // Add this import

class AppUser {
  final String uid;
  final String email;
  final String? displayName;
  final DateTime? createdAt;

  AppUser({
    required this.uid,
    required this.email,
    this.displayName,
    this.createdAt,
  });

  factory AppUser.fromFirebaseUser(User user) {
    return AppUser(
      uid: user.uid,
      email: user.email ?? '', // Handle null email
      displayName: user.displayName,
      createdAt: user.metadata.creationTime,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'createdAt': createdAt?.millisecondsSinceEpoch,
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      displayName: map['displayName'],
      createdAt: map['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'])
          : null,
    );
  }
}