
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sospet/model/pet_report_model.dart';


class PetReportService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late final CollectionReference _reportsCollection =
  _firestore.collection('pet_reports');
  late final CollectionReference _usersCollection = 
  _firestore.collection('users');

  Future<void> addPetReport(Map<String, dynamic> reportData) async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception("Usuário não autenticado. Faça login para reportar.");
      }

      
      String? reporterPhoneNumber;
      try {
        DocumentSnapshot userDoc = await _usersCollection.doc(currentUser.uid).get();
        if (userDoc.exists) {
          
          
          Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
          reporterPhoneNumber = userData['phoneNumber'] as String?;
        }
      } catch (e) {
        print("Error fetching reporter's phone number: $e");
        
      }

      reportData['userId'] = currentUser.uid;
      reportData['reporterName'] = currentUser.displayName ?? 'Usuário Anônimo';
      reportData['reporterEmail'] = currentUser.email ?? '';
      reportData['reporterPhoneNumber'] = reporterPhoneNumber; 

      await _reportsCollection.add(reportData);
      print('Relatório adicionado ao Firestore com sucesso (com telefone do reportante, se disponível)!');
    } on FirebaseException catch (e) {
      print('FirebaseException ao adicionar relatório: ${e.code} - ${e.message}');
      throw 'Erro ao salvar relatório no servidor: ${e.message}';
    } catch (e) {
      print('Erro desconhecido ao adicionar relatório: $e');
      throw 'Ocorreu um erro inesperado: ${e.toString()}';
    }
  }

  Stream<List<PetReportModel>> getPetReportsStream() {
    return _reportsCollection
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      try {
        return snapshot.docs
            .map((doc) => PetReportModel.fromFirestore(doc))
            .toList();
      } catch (e) {
        print('Error parsing pet reports: $e');
        return [];
      }
    });
  }
}