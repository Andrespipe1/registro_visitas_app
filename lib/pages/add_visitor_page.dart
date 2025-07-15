import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/db_service.dart';
import '../services/auth_service.dart';
import 'package:intl/intl.dart';

class AddVisitorPage extends StatefulWidget {
  const AddVisitorPage({super.key});

  @override
  State<AddVisitorPage> createState() => _AddVisitorPageState();
}

class _AddVisitorPageState extends State<AddVisitorPage> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _motivoController = TextEditingController();
  DateTime _hora = DateTime.now();
  XFile? _foto;
  Uint8List? _fotoBytes;
  bool _loading = false;
  String? _error;

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _hora,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_hora),
      );
      if (pickedTime != null) {
        setState(() {
          _hora = DateTime(
            picked.year,
            picked.month,
            picked.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _foto = pickedFile;
        _fotoBytes = bytes;
      });
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate() || _fotoBytes == null) {
      setState(() { _error = 'Todos los campos y la foto son obligatorios.'; });
      return;
    }
    setState(() { _loading = true; _error = null; });
    try {
      final user = AuthService().currentUser;
      if (user == null) throw Exception('Usuario no autenticado');
      await DBService().agregarVisitante(
        nombre: _nombreController.text.trim(),
        motivo: _motivoController.text.trim(),
        hora: _hora,
        fotoBytes: _fotoBytes!,
        userId: user.id,
      );
      if (mounted) Navigator.pop(context);
    } catch (e) {
      setState(() { _error = e.toString(); });
    } finally {
      setState(() { _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Agregar visitante')),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF5F5F5), Color(0xFFE3F2FD)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Padding(
                padding: const EdgeInsets.all(28.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Nuevo visitante', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 18),
                      GestureDetector(
                        onTap: _pickImage,
                        child: _fotoBytes == null
                            ? CircleAvatar(
                                radius: 40,
                                backgroundColor: const Color(0xFF1976D2),
                                child: const Icon(Icons.camera_alt, color: Colors.white, size: 36),
                              )
                            : CircleAvatar(
                                radius: 40,
                                backgroundImage: MemoryImage(_fotoBytes!),
                              ),
                      ),
                      const SizedBox(height: 18),
                      TextFormField(
                        controller: _nombreController,
                        decoration: const InputDecoration(
                          labelText: 'Nombre del visitante',
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                        validator: (v) => v == null || v.isEmpty ? 'Campo obligatorio' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _motivoController,
                        decoration: const InputDecoration(
                          labelText: 'Motivo de la visita',
                          prefixIcon: Icon(Icons.assignment_turned_in_outlined),
                        ),
                        validator: (v) => v == null || v.isEmpty ? 'Campo obligatorio' : null,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const Icon(Icons.access_time, color: Color(0xFF1976D2)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text('Hora: ${DateFormat('dd/MM/yyyy · HH:mm').format(_hora)}'),
                          ),
                          TextButton(
                            onPressed: _pickDate,
                            child: const Text('Cambiar'),
                          ),
                        ],
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
                          onPressed: _loading ? null : _save,
                          icon: const Icon(Icons.save_alt),
                          label: _loading
                              ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                              : const Text('Guardar'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
} 