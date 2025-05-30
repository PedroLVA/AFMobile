// lib/models/pet_report_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class PetReportModel {
  final String id;
  final String animalType;
  final String status;
  final String approximateAddress;
  final String? specificBreed;
  final String predominantColor;
  final String size;
  final String? specialCharacteristics;
  final String reportDate;
  final String? photoUrl;
  final DateTime timestamp;
  final String userId;
  final String reporterName;
  final String? reporterEmail;
  final String? reporterPhoneNumber; // <-- ADDED

  PetReportModel({
    required this.id,
    required this.animalType,
    required this.status,
    required this.approximateAddress,
    this.specificBreed,
    required this.predominantColor,
    required this.size,
    this.specialCharacteristics,
    required this.reportDate,
    this.photoUrl,
    required this.timestamp,
    required this.userId,
    required this.reporterName,
    this.reporterEmail,
    this.reporterPhoneNumber, // <-- ADDED to constructor
  });

  factory PetReportModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return PetReportModel(
      id: doc.id,
      animalType: data['animalType'] ?? 'Animal Desconhecido',
      status: data['status'] ?? 'Status Desconhecido',
      approximateAddress: data['approximateAddress'] ?? 'Endereço não informado',
      specificBreed: data['specificBreed'],
      predominantColor: data['predominantColor'] ?? 'Cor não informada',
      size: data['size'] ?? 'Tamanho não informado',
      specialCharacteristics: data['specialCharacteristics'],
      reportDate: data['reportDate'] ?? 'Data não informada',
      photoUrl: data['photoUrl'],
      timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      userId: data['userId'] ?? '',
      reporterName: data['reporterName'] ?? 'Reportante Anônimo',
      reporterEmail: data['reporterEmail'],
      reporterPhoneNumber: data['reporterPhoneNumber'], // <-- PARSE from Firestore data
    );
  }
}