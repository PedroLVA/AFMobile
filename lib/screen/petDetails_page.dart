// lib/pet_details_page.dart
import 'package:flutter/material.dart';
import 'package:sospet/model/pet_report_model.dart';

// import 'package:url_launcher/url_launcher.dart'; // For "mailto" links

class PetDetailsPage extends StatelessWidget {
  final PetReportModel petReport;

  const PetDetailsPage({Key? key, required this.petReport}) : super(key: key);

  // Helper to launch email (optional)
  // Future<void> _launchEmail(String? email) async {
  //   if (email != null && email.isNotEmpty) {
  //     final Uri emailLaunchUri = Uri(
  //       scheme: 'mailto',
  //       path: email,
  //       queryParameters: {
  //         'subject': 'Contato sobre o pet: ${petReport.animalType} (${petReport.status})'
  //       }
  //     );
  //     if (await canLaunchUrl(emailLaunchUri)) {
  //       await launchUrl(emailLaunchUri);
  //     } else {
  //       // Handle error, e.g., show a SnackBar
  //       print('Could not launch $emailLaunchUri');
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: Text('${petReport.animalType} ${petReport.status}'),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pet Image Placeholder
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: 250,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(12),
                  // In a real app:
                  // image: petReport.photoUrl != null && petReport.photoUrl!.isNotEmpty
                  //     ? DecorationImage(
                  //         image: NetworkImage(petReport.photoUrl!),
                  //         fit: BoxFit.cover,
                  //       )
                  //     : null,
                ),
                child: Icon(
                  Icons.pets,
                  size: 100,
                  color: Colors.grey[500],
                ),
              ),
            ),
            SizedBox(height: 24),

            _buildSectionTitle('Detalhes do Pet'),
            _buildDetailItem('Status:', petReport.status),
            _buildDetailItem('Tipo:', petReport.animalType),
            _buildDetailItem('Raça:', petReport.specificBreed ?? 'Não informada'),
            _buildDetailItem('Cor Predominante:', petReport.predominantColor),
            _buildDetailItem('Tamanho:', petReport.size),
            _buildDetailItem('Características Especiais:', petReport.specialCharacteristics?.isNotEmpty == true ? petReport.specialCharacteristics! : 'Nenhuma'),
            _buildDetailItem('Endereço Aproximado:', petReport.approximateAddress),
            _buildDetailItem('Data do Evento/Reporte:', petReport.reportDate),
            SizedBox(height: 24),

            _buildSectionTitle('Informações do Reportante'),
            _buildDetailItem('Nome:', petReport.reporterName),
            if (petReport.reporterEmail != null && petReport.reporterEmail!.isNotEmpty)
              Card(
                elevation: 1,
                margin: EdgeInsets.symmetric(vertical: 4),
                child: ListTile(
                  leading: Icon(Icons.email, color: Colors.blue[700]),
                  title: Text(petReport.reporterEmail!),
                  subtitle: Text('Toque para enviar um email (simulação)'),
                  onTap: () {
                    // _launchEmail(petReport.reporterEmail); // Uncomment if using url_launcher
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Simulando envio de email para: ${petReport.reporterEmail}')),
                    );
                  },
                ),
              ),
            SizedBox(height: 16),
            Text(
              'ID do Reporte: ${petReport.id}',
              style: TextStyle(color: Colors.grey[500], fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.blue[800]),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Card(
        elevation: 0.5,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700]),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  value,
                  style: TextStyle(fontSize: 15, color: Colors.grey[850]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}