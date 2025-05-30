// lib/pet_details_page.dart
import 'package:flutter/material.dart';
import 'package:sospet/model/pet_report_model.dart';
import 'package:url_launcher/url_launcher.dart';

// import 'package:url_launcher/url_launcher.dart'; // For "mailto" links

class PetDetailsPage extends StatelessWidget {
  final PetReportModel petReport;

  const PetDetailsPage({Key? key, required this.petReport}) : super(key: key);

  Future<void> _launchUniversalLink(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      print('Could not launch $url');
      // Optionally show a SnackBar to the user
      // ScaffoldMessenger.of(scaffoldContext).showSnackBar(SnackBar(content: Text('Não foi possível abrir o link.')));
    }
  }

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
            // Pet Image Placeholder (existing code)
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: 250,
                decoration: BoxDecoration( /* ... */ ),
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

            // Display Email (existing code, modified for _launchUniversalLink)
            if (petReport.reporterEmail != null && petReport.reporterEmail!.isNotEmpty)
              Card(
                elevation: 1,
                margin: EdgeInsets.symmetric(vertical: 4),
                child: ListTile(
                  leading: Icon(Icons.email, color: Colors.blue[700]),
                  title: Text(petReport.reporterEmail!),
                  subtitle: Text('Toque para enviar email'),
                  onTap: () {
                    _launchUniversalLink('mailto:${petReport.reporterEmail}?subject=Contato sobre o pet: ${petReport.animalType} (${petReport.status})');
                  },
                ),
              ),

            // --- DISPLAY PHONE NUMBER ---
            if (petReport.reporterPhoneNumber != null && petReport.reporterPhoneNumber!.isNotEmpty)
              Card(
                elevation: 1,
                margin: EdgeInsets.symmetric(vertical: 4),
                child: ListTile(
                  leading: Icon(Icons.phone, color: Colors.green[700]),
                  title: Text(petReport.reporterPhoneNumber!),
                  subtitle: Text('Toque para ligar (simulação) ou copiar'),
                  onTap: () {
                    // For actual calling, use: _launchUniversalLink('tel:${petReport.reporterPhoneNumber}');
                    // For now, just a SnackBar or copy to clipboard functionality
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Número para contato: ${petReport.reporterPhoneNumber}')),
                    );
                    // You could also add copy to clipboard functionality here
                    // Clipboard.setData(ClipboardData(text: petReport.reporterPhoneNumber!));
                    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Número copiado!')));
                  },
                  onLongPress: () { // Example: Long press to try launching call
                    _launchUniversalLink('tel:${petReport.reporterPhoneNumber}');
                  },
                ),
              ),
            // --- END PHONE NUMBER ---

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