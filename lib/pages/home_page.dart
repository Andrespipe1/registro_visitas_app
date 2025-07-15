import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/visitor.dart';
import '../services/db_service.dart';
import '../services/auth_service.dart';
import '../widgets/visitor_card.dart';
import 'add_visitor_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final String userId;
  final DBService _dbService = DBService();

  @override
  void initState() {
    super.initState();
    final user = AuthService().currentUser;
    userId = user?.id ?? '';
  }

  void _logout() async {
    await AuthService().signOut();
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  void _goToAddVisitor() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddVisitorPage()),
    );
    setState(() {}); // Refresca la lista al volver
  }

  void _deleteVisitor(String id) async {
    try {
      await _dbService.deleteVisitante(id);
      if (mounted) {
        setState(() {}); // Forzar actualización inmediata
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Visitante eliminado correctamente')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al eliminar: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (userId.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('Usuario no autenticado')),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.white,
              child: Icon(Icons.business, color: Color(0xFF1976D2), size: 20),
            ),
            const SizedBox(width: 8),
            const Text('Oficina Central', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Cerrar sesión',
          ),
        ],
        backgroundColor: const Color(0xFF1976D2),
        elevation: 4,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF5F5F5), Color(0xFFE3F2FD)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: StreamBuilder<List<Visitante>>(
          stream: _dbService.visitantesStream(userId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: \\${snapshot.error}'));
            }
            final visitantes = snapshot.data ?? [];
            if (visitantes.isEmpty) {
              return const Center(
                child: Text(
                  'No hay visitantes registrados.',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              itemCount: visitantes.length,
              itemBuilder: (context, index) {
                final visitante = visitantes[index];
                return VisitorCard(
                  visitante: visitante,
                  onDelete: () => _deleteVisitor(visitante.id),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToAddVisitor,
        icon: const Icon(Icons.person_add_alt_1),
        label: const Text('Nuevo visitante'),
        backgroundColor: const Color(0xFF43A047),
        elevation: 6,
      ),
    );
  }
} 