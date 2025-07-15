import 'package:flutter/material.dart';
import '../models/visitor.dart';
import 'package:intl/intl.dart';

class VisitorCard extends StatelessWidget {
  final Visitante visitante;
  final void Function()? onDelete;
  const VisitorCard({super.key, required this.visitante, this.onDelete});

  void _showDeleteDialog(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar visitante'),
        content: const Text('¿Estás seguro de que deseas eliminar este visitante?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE53935)),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (confirm == true && onDelete != null) {
      onDelete!();
    }
  }

  @override
  Widget build(BuildContext context) {
    final horaFormateada = DateFormat('dd/MM/yyyy · HH:mm').format(visitante.hora);
    return GestureDetector(
      onLongPress: () => _showDeleteDialog(context),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: const Color(0xFF1976D2),
                backgroundImage: NetworkImage(visitante.fotoUrl),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      visitante.nombre,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Color(0xFF263238),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.assignment_turned_in, size: 18, color: Color(0xFF43A047)),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            visitante.motivo,
                            style: const TextStyle(fontSize: 15, color: Color(0xFF263238)),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.access_time, size: 16, color: Color(0xFF1976D2)),
                        const SizedBox(width: 6),
                        Text(
                          horaFormateada,
                          style: const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
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
} 