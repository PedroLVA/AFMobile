
import 'package:flutter/material.dart';
import 'package:sospet/service/PetReportService.dart';


class ReportPetPage extends StatefulWidget {
  @override
  _ReportPetPageState createState() => _ReportPetPageState();
}

class _ReportPetPageState extends State<ReportPetPage> {
  final _formKey = GlobalKey<FormState>();
  final PetReportService _reportService = PetReportService();


  String? _animalType;
  String? _status;
  final _addressController = TextEditingController();
  final _breedController = TextEditingController();
  final _colorController = TextEditingController();
  String? _size;
  final _specialCharacteristicsController = TextEditingController();
  final _reportDateController = TextEditingController();

  bool _isLoading = false;


  String? _photoPlaceholder;

  @override
  void dispose() {
    _addressController.dispose();
    _breedController.dispose();
    _colorController.dispose();
    _specialCharacteristicsController.dispose();
    _reportDateController.dispose();
    super.dispose();
  }

  Future<void> _selectReportDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      locale: Locale('pt', 'BR'),
    );
    if (picked != null) {
      setState(() {
        _reportDateController.text = "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
      });
    }
  }

  void _submitReport() async {
    if (_formKey.currentState!.validate()) {
      if (_photoPlaceholder == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Por favor, adicione uma "foto" (simulação).'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      setState(() => _isLoading = true);

      try {

        Map<String, dynamic> reportData = {
          'animalType': _animalType,
          'status': _status,
          'approximateAddress': _addressController.text.trim(),
          'specificBreed': _breedController.text.trim(),
          'predominantColor': _colorController.text.trim(),
          'size': _size,
          'specialCharacteristics': _specialCharacteristicsController.text.trim(),
          'reportDate': _reportDateController.text.trim(),
          'photoUrl': _photoPlaceholder,
          'timestamp': DateTime.now(),
        };

        await _reportService.addPetReport(reportData);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Relatório enviado com sucesso!'),
              backgroundColor: Colors.green,
            ),
          );
          _formKey.currentState?.reset();
          _addressController.clear();
          _breedController.clear();
          _colorController.clear();
          _specialCharacteristicsController.clear();
          _reportDateController.clear();
          setState(() {
            _animalType = null;
            _status = null;
            _size = null;
            _photoPlaceholder = null;
          });
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro ao enviar relatório: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: Text('Reportar Pet'),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Detalhes do Pet',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[800]),
                ),
                SizedBox(height: 20),


                DropdownButtonFormField<String>(
                  decoration: _inputDecoration('Tipo do Animal'),
                  value: _animalType,
                  hint: Text('Selecione o tipo'),
                  items: ['Cachorro', 'Gato', 'Outro']
                      .map((label) => DropdownMenuItem(
                    child: Text(label),
                    value: label,
                  ))
                      .toList(),
                  onChanged: (value) => setState(() => _animalType = value),
                  validator: (value) =>
                  value == null ? 'Campo obrigatório' : null,
                ),
                SizedBox(height: 16),


                DropdownButtonFormField<String>(
                  decoration: _inputDecoration('Status'),
                  value: _status,
                  hint: Text('Selecione o status'),
                  items: ['Perdido', 'Encontrado']
                      .map((label) => DropdownMenuItem(
                    child: Text(label),
                    value: label,
                  ))
                      .toList(),
                  onChanged: (value) => setState(() => _status = value),
                  validator: (value) =>
                  value == null ? 'Campo obrigatório' : null,
                ),
                SizedBox(height: 16),

                // Approximate Address
                TextFormField(
                  controller: _addressController,
                  decoration: _inputDecoration('Endereço Aproximado'),
                  validator: (value) =>
                  value == null || value.isEmpty ? 'Campo obrigatório' : null,
                ),
                SizedBox(height: 16),


                TextFormField(
                  controller: _breedController,
                  decoration: _inputDecoration('Raça Específica'),

                ),
                SizedBox(height: 16),


                TextFormField(
                  controller: _colorController,
                  decoration: _inputDecoration('Cor Predominante'),
                  validator: (value) =>
                  value == null || value.isEmpty ? 'Campo obrigatório' : null,
                ),
                SizedBox(height: 16),

                DropdownButtonFormField<String>(
                  decoration: _inputDecoration('Tamanho'),
                  value: _size,
                  hint: Text('Selecione o tamanho'),
                  items: ['Pequeno', 'Médio', 'Grande']
                      .map((label) => DropdownMenuItem(
                    child: Text(label),
                    value: label,
                  ))
                      .toList(),
                  onChanged: (value) => setState(() => _size = value),
                  validator: (value) =>
                  value == null ? 'Campo obrigatório' : null,
                ),
                SizedBox(height: 16),

                TextFormField(
                  controller: _specialCharacteristicsController,
                  decoration: _inputDecoration('Características Especiais (opcional)'),
                  maxLines: 3,
                ),
                SizedBox(height: 16),


                TextFormField(
                  controller: _reportDateController,
                  decoration: _inputDecoration('Data do Evento (DD/MM/AAAA)', suffixIcon: Icon(Icons.calendar_today)),
                  readOnly: true,
                  onTap: _selectReportDate,
                  validator: (value) =>
                  value == null || value.isEmpty ? 'Campo obrigatório' : null,
                ),
                SizedBox(height: 24),


                Text(
                  'Foto do Pet (Simulação)',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey[700]),
                ),
                SizedBox(height: 8),
                OutlinedButton.icon(
                  icon: Icon(_photoPlaceholder != null ? Icons.check_circle : Icons.add_a_photo),
                  label: Text(_photoPlaceholder != null ? 'Foto "Adicionada"' : 'Adicionar Foto (Simulação)'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _photoPlaceholder != null ? Colors.green : Colors.blue[700],
                    side: BorderSide(color: _photoPlaceholder != null ? Colors.green : Colors.blue[700]!),
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () {

                    setState(() {
                      _photoPlaceholder = 'simulated_image_path_${DateTime.now().millisecondsSinceEpoch}.jpg';
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Foto simulada adicionada!'), backgroundColor: Colors.blue),
                    );
                  },
                ),
                if (_photoPlaceholder == null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      'É necessário adicionar pelo menos uma foto (simulação).',
                      style: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 12),
                    ),
                  ),
                SizedBox(height: 30),

                // Submit Button
                ElevatedButton.icon(
                  icon: _isLoading ? SizedBox.shrink() : Icon(Icons.send),
                  label: _isLoading
                      ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                      : Text('Enviar Relatório'),
                  onPressed: _isLoading ? null : _submitReport,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[800],
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    textStyle: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, {Widget? suffixIcon}) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.blue[700]!),
      ),
      suffixIcon: suffixIcon,
    );
  }
}