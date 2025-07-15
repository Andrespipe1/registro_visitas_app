import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;
  String? _error;

  void _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() { _loading = true; _error = null; });
    try {
      final auth = AuthService();
      final res = await auth.signIn(_emailController.text, _passwordController.text);
      if (res.user != null) {
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      } else {
        setState(() {
          final errorMsg = res.toString();
          if (errorMsg.contains('Email not confirmed')) {
            _error = 'Por favor, confirma tu cuenta desde el correo electrónico.';
          } else {
            _error = 'No se pudo iniciar sesión. Verifica tus datos.';
          }
        });
      }
    } catch (e) {
      setState(() {
        final errorMsg = e.toString();
        if (errorMsg.contains('Email not confirmed')) {
          _error = 'Por favor, confirma tu cuenta desde el correo electrónico.';
        } else {
          _error = 'No se pudo iniciar sesión. Verifica tus datos.';
        }
      });
    } finally {
      setState(() { _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1976D2), Color(0xFF43A047)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              margin: const EdgeInsets.symmetric(horizontal: 24),
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Logo ficticio
                    CircleAvatar(
                      radius: 36,
                      backgroundColor: const Color(0xFF1976D2),
                      child: Icon(Icons.business, color: Colors.white, size: 40),
                    ),
                    const SizedBox(height: 16),
                    Text('Bienvenido', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text('Registro de Visitas', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey[700])),
                    const SizedBox(height: 24),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                              labelText: 'Correo electrónico',
                              prefixIcon: Icon(Icons.email_outlined),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) => value != null && value.contains('@') ? null : 'Correo inválido',
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _passwordController,
                            decoration: const InputDecoration(
                              labelText: 'Contraseña',
                              prefixIcon: Icon(Icons.lock_outline),
                            ),
                            obscureText: true,
                            validator: (value) => value != null && value.length >= 6 ? null : 'Mínimo 6 caracteres',
                          ),
                          const SizedBox(height: 24),
                          if (_error != null)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Text(_error!, style: const TextStyle(color: Color(0xFFE53935), fontWeight: FontWeight.bold)),
                            ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: _loading ? null : _login,
                              icon: const Icon(Icons.login),
                              label: _loading
                                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                  : const Text('Iniciar sesión'),
                            ),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pushReplacementNamed(context, '/register'),
                            child: const Text('¿No tienes cuenta? Regístrate'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
} 