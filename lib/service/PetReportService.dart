// lib/service/pet_report_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sospet/model/pet_report_model.dart';
 // <-- ADD THIS IMPORT

class PetReportService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late final CollectionReference _reportsCollection =
  _firestore.collection('pet_reports');

  // Add a new pet report (existing method)
  Future<void> addPetReport(Map<String, dynamic> reportData) async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception("Usuário não autenticado. Faça login para reportar.");
      }
      reportData['userId'] = currentUser.uid;
      reportData['reporterName'] = currentUser.displayName ?? 'Usuário Anônimo';
      reportData['reporterEmail'] = currentUser.email ?? '';
      await _reportsCollection.add(reportData);
      print('Relatório adicionado ao Firestore com sucesso!');
    } on FirebaseException catch (e) {
      print('FirebaseException ao adicionar relatório: ${e.code} - ${e.message}');
      throw 'Erro ao salvar relatório no servidor: ${e.message}';
    } catch (e) {
      print('Erro desconhecido ao adicionar relatório: $e');
      throw 'Ocorreu um erro inesperado: ${e.toString()}';
    }
  }

  // --- NEW METHOD TO GET PET REPORTS ---
  Stream<List<PetReportModel>> getPetReportsStream() {
    return _reportsCollection
        .orderBy('timestamp', descending: true) // Show newest first
        .snapshots()
        .map((snapshot) {
      try {
        return snapshot.docs
            .map((doc) => PetReportModel.fromFirestore(doc))
            .toList();
      } catch (e) {
        print('Error parsing pet reports: $e');
        // Optionally, rethrow or return an empty list with an error indicator
        return [];
      }
    });
  }
// --- END NEW METHOD ---
}