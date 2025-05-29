// services/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Auth state changes stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign in with email and password
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

  // Register with email and password
  Future<UserCredential?> registerWithEmailAndPassword(String email, String password, String name) async {
    try {
      debugPrint('Attempting to register with email: $email');

      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      debugPrint('Registration successful for user: ${result.user?.uid}');

      // Update display name with better error handling
      if (result.user != null) {
        try {
          await result.user!.updateDisplayName(name);
          await result.user!.reload(); // Reload to get updated info
          debugPrint('Display name updated successfully');
        } catch (e) {
          debugPrint('Error updating display name: $e');
          // Don't throw here, registration was successful
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

  // Sign out
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

  // Reset password
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

  // Delete account
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

  // Handle Firebase Auth exceptions and return user-friendly messages in Portuguese
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