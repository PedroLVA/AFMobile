// lib/home_page.dart (Your existing file, with modifications)
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sospet/screen/reportPet_page.dart';
import 'package:sospet/screen/searchPet_page.dart';
import 'package:sospet/service/AuthService.dart';
import 'login_page.dart';

class HomePage extends StatelessWidget {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(

      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: Text('SOS Pet'),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert),
            onSelected: (value) async {
              if (value == 'logout') {
                try {
                  await _authService.signOut();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                        (Route<dynamic> route) => false,
                  );
                } catch (e) {
                  if (ScaffoldMessenger.of(context).mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(e.toString())),
                    );
                  }
                }
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, color: Colors.grey[700]),
                    SizedBox(width: 8),
                    Text('Sair'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.pets,
                      size: 40,
                      color: Colors.blue[800],
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Olá, ${user?.displayName ?? 'Pet Lover'}!',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[800],
                            ),
                          ),
                          Text(
                            user?.email ?? '',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),

              Text(
                'O que você gostaria de fazer?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
              ),
              SizedBox(height: 20),

              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    _buildActionCard(
                      context,
                      'Procurar Pets',
                      Icons.search,
                      Colors.green,
                          () {

                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SearchPetsPage()),
                        );

                      },
                    ),
                    _buildActionCard(
                      context,
                      'Reportar Pet',
                      Icons.add_alert,
                      Colors.orange,
                          () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ReportPetPage()),
                        );
                      },
                    ),
                    _buildActionCard(
                      context,
                      'Meus Anúncios',
                      Icons.list_alt,
                      Colors.blue,
                          () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Funcionalidade em desenvolvimento...')),
                        );
                      },
                    ),
                    _buildActionCard(
                      context,
                      'Perfil',
                      Icons.person,
                      Colors.purple,
                          () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Funcionalidade em desenvolvimento...')),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildActionCard(BuildContext context, String title, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 40,
                color: color,
              ),
              SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}