
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:sospet/model/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  
  User? get currentUser => _auth.currentUser;

  
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  
  Future<UserCredential?> signInWithEmailAndPassword(String email, String password) async {
    try {
      debugPrint('Attempting to sign in with email: $email');

      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      debugPrint('Sign in successful for user: ${result.user?.uid}');
      return result;

    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException during sign in: ${e.code} - ${e.message}');
      throw _handleAuthException(e);
    } catch (e) {
      debugPrint('Unexpected error during sign in: $e');
      throw 'Erro inesperado: ${e.toString()}';
    }
  }

  
  Future<UserCredential?> registerWithEmailAndPassword(
      String email,
      String password,
      String name,
      String phoneNumber, 
      ) async {
    try {
      debugPrint('Attempting to register with email: $email');

      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      debugPrint('Registration successful for Firebase Auth user: ${result.user?.uid}');

      User? firebaseUser = result.user;

      if (firebaseUser != null) {
        
        try {
          await firebaseUser.updateDisplayName(name);
          
          await firebaseUser.reload();
          firebaseUser = _auth.currentUser; 
          debugPrint('Display name updated successfully in Firebase Auth');
        } catch (e) {
          debugPrint('Error updating display name in Firebase Auth: $e');
          
        }

        
        try {
          AppUser appUser = AppUser(
            uid: firebaseUser!.uid, 
            email: firebaseUser.email ?? email.trim(), 
            displayName: firebaseUser.displayName ?? name, 
            phoneNumber: phoneNumber,
            createdAt: firebaseUser.metadata.creationTime ?? DateTime.now(),
          );

          await _firestore
              .collection('users') 
              .doc(firebaseUser.uid)
              .set(appUser.toMap());
          debugPrint('User profile created in Firestore for UID: ${firebaseUser.uid}');

        } catch (e) {
          debugPrint('Error creating user profile in Firestore: $e');
          
          
          
          
        }
      }
      return result; 

    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException during registration: ${e.code} - ${e.message}');
      throw _handleAuthException(e);
    } catch (e) {
      debugPrint('Unexpected error during registration: $e');
      throw 'Erro inesperado: ${e.toString()}';
    }
  }

  
  Future<void> signOut() async {
    try {
      debugPrint('Attempting to sign out');
      await _auth.signOut();
      debugPrint('Sign out successful');
    } catch (e) {
      debugPrint('Error during sign out: $e');
      throw 'Erro ao fazer logout: ${e.toString()}';
    }
  }

  
  Future<void> resetPassword(String email) async {
    try {
      debugPrint('Attempting to reset password for: $email');
      await _auth.sendPasswordResetEmail(email: email.trim());
      debugPrint('Password reset email sent successfully');
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException during password reset: ${e.code} - ${e.message}');
      throw _handleAuthException(e);
    } catch (e) {
      debugPrint('Unexpected error during password reset: $e');
      throw 'Erro inesperado: ${e.toString()}';
    }
  }

  
  Future<void> deleteAccount() async {
    try {
      debugPrint('Attempting to delete account');
      await _auth.currentUser?.delete();
      debugPrint('Account deleted successfully');
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException during account deletion: ${e.code} - ${e.message}');
      throw _handleAuthException(e);
    } catch (e) {
      debugPrint('Unexpected error during account deletion: $e');
      throw 'Erro inesperado: ${e.toString()}';
    }
  }

  
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'Usuário não encontrado.';
      case 'wrong-password':
        return 'Senha incorreta.';
      case 'email-already-in-use':
        return 'Este email já está em uso.';
      case 'weak-password':
        return 'A senha é muito fraca.';
      case 'invalid-email':
        return 'Email inválido.';
      case 'user-disabled':
        return 'Esta conta foi desabilitada.';
      case 'too-many-requests':
        return 'Muitas tentativas. Tente novamente mais tarde.';
      case 'operation-not-allowed':
        return 'Operação não permitida.';
      case 'requires-recent-login':
        return 'É necessário fazer login novamente para esta operação.';
      case 'invalid-credential':
        return 'Credenciais inválidas.';
      case 'account-exists-with-different-credential':
        return 'Já existe uma conta com este email usando um método diferente.';
      case 'credential-already-in-use':
        return 'Esta credencial já está sendo usada por outra conta.';
      default:
        debugPrint('Unhandled FirebaseAuthException: ${e.code} - ${e.message}');
        return 'Erro de autenticação: ${e.message ?? 'Erro desconhecido'}';
    }
  }
}