// lib/search_pets_page.dart
import 'package:flutter/material.dart';
import 'package:sospet/model/pet_report_model.dart';
import 'package:sospet/screen/petDetails_page.dart';
import 'package:sospet/service/PetReportService.dart';
 // We'll create this next

class SearchPetsPage extends StatefulWidget {
  @override
  _SearchPetsPageState createState() => _SearchPetsPageState();
}

class _SearchPetsPageState extends State<SearchPetsPage> {
  final PetReportService _reportService = PetReportService();

  Color _getStatusColor(String status) {
    if (status.toLowerCase() == 'encontrado') {
      return Colors.deepPurple; // Color from the image badge
    } else if (status.toLowerCase() == 'perdido') {
      return Colors.orange;
    }
    return Colors.grey;
  }

  String _getAvatarLetter(String status) {
    if (status.isEmpty) return '?';
    // Using the first letter of the status for the avatar as per refined thought
    return status[0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: Text('Procurar Pets'),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<List<PetReportModel>>(
        stream: _reportService.getPetReportsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            print('Error in StreamBuilder: ${snapshot.error}');
            return Center(child: Text('Erro ao carregar os dados. Tente novamente.'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Nenhum pet reportado ainda.'));
          }

          List<PetReportModel> reports = snapshot.data!;

          return ListView.builder(
            padding: EdgeInsets.all(12),
            itemCount: reports.length,
            itemBuilder: (context, index) {
              PetReportModel pet = reports[index];
              return _buildPetCard(context, pet);
            },
          );
        },
      ),
    );
  }

  Widget _buildPetCard(BuildContext context, PetReportModel pet) {
    Color statusColor = _getStatusColor(pet.status);
    String title = '${pet.animalType} ${pet.status}'; // Dynamic title: e.g. "Cachorro Encontrado"
    String subtitle = '${pet.size} - ${pet.predominantColor}';

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      clipBehavior: Clip.antiAlias, // Important for the badge to look good
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PetDetailsPage(petReport: pet)),
          );
        },
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: statusColor.withOpacity(0.2),
                    child: Text(
                      _getAvatarLetter(pet.status),
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: statusColor),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12),
                  // Placeholder for Pet Image
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                      // In a real app, you'd use Image.network(pet.photoUrl!)
                      // if (pet.photoUrl != null && pet.photoUrl!.isNotEmpty)
                      //   image: DecorationImage(
                      //     image: NetworkImage(pet.photoUrl!),
                      //     fit: BoxFit.cover,
                      //   ),
                    ),
                    child: Icon(
                      Icons.pets, // Placeholder icon
                      color: Colors.grey[500],
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
            // Status Badge (Top-Left)
            Positioned(
              top: 0,
              left: 0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12), // Match card radius
                    bottomRight: Radius.circular(12),
                  ),
                ),
                child: Text(
                  pet.status.toUpperCase(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}