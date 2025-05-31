
import 'package:flutter/material.dart';
import 'package:sospet/service/AuthService.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;



  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        await _authService.registerWithEmailAndPassword(
          _emailController.text.trim(),
          _passwordController.text,
          _nameController.text.trim(),
          _phoneController.text.trim(),
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Conta criada com sucesso! Verifique seu email para login.'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.toString()),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }
 // Helper for consistent InputDecoration
  InputDecoration _buildInputDecoration(String labelText, IconData prefixIconData, {Widget? suffixIcon}) {
    return InputDecoration(
      labelText: labelText,
      prefixIcon: Icon(prefixIconData),
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      filled: true,
      fillColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: Text('Criar Conta'),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 20),
                Icon(
                  Icons.pets,
                  size: 80,
                  color: Colors.blue[800],
                ),
                SizedBox(height: 20),
                Text(
                  'Junte-se ao SOS Pet',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800],
                  ),
                ),
                SizedBox(height: 32),


                TextFormField(
                  controller: _nameController,
                  enabled: !_isLoading,
                  decoration: _buildInputDecoration('Nome completo', Icons.person),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira seu nome';
                    }
                    if (value.length < 2) {
                      return 'Nome deve ter pelo menos 2 caracteres';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),


                TextFormField(
                  controller: _emailController,
                  enabled: !_isLoading,
                  keyboardType: TextInputType.emailAddress,
                  decoration: _buildInputDecoration('Email', Icons.email),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira seu email';
                    }
                    if (!value.contains('@')) {
                      return 'Por favor, insira um email válido';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),


                TextFormField(
                  controller: _phoneController,
                  enabled: !_isLoading,
                  keyboardType: TextInputType.phone,

                  decoration: _buildInputDecoration('Celular (ex: 11912345678)', Icons.phone), // <-- Using helper
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira seu celular';
                    }
                    final phoneRegExp = RegExp(r'^\d{10,11}$');
                    if (!phoneRegExp.hasMatch(value.replaceAll(RegExp(r'\D'), ''))) {
                      return 'Número de celular inválido';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),


                TextFormField(
                  controller: _passwordController,
                  enabled: !_isLoading,
                  obscureText: _obscurePassword,
                  decoration: _buildInputDecoration(
                    'Senha',
                    Icons.lock,
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira uma senha';
                    }
                    if (value.length < 6) {
                      return 'Senha deve ter pelo menos 6 caracteres';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                TextFormField(
                  controller: _confirmPasswordController,
                  enabled: !_isLoading,
                  obscureText: _obscureConfirmPassword,
                  decoration: _buildInputDecoration(
                    'Confirmar senha',
                    Icons.lock_outline,
                    suffixIcon: IconButton(
                      icon: Icon(_obscureConfirmPassword ? Icons.visibility : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, confirme sua senha';
                    }
                    if (value != _passwordController.text) {
                      return 'Senhas não coincidem';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 32),

                ElevatedButton(
                  onPressed: _isLoading ? null : _handleRegister,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[800],
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: _isLoading
                      ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                      : Text(
                    'Criar Conta',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 24),


                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Já tem uma conta? ',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    TextButton(
                      onPressed: _isLoading ? null : () => Navigator.pop(context),
                      child: Text(
                        'Fazer login',
                        style: TextStyle(
                          color: Colors.blue[800],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}