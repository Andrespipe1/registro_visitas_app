import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/visitor.dart';

class DBService {
  final SupabaseClient _client = Supabase.instance.client;
  final String bucket = 'fotosvisitantes';
  final String table = 'visitantes';

  // Stream de visitantes en tiempo real
  Stream<List<Visitante>> visitantesStream(String userId) {
    return _client
        .from(table)
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .order('hora', ascending: false)
        .map((data) => data
            .map((e) {
              final map = e as Map<String, dynamic>;
              return Visitante(
                id: map['id'],
                nombre: map['nombre'],
                motivo: map['motivo'],
                hora: DateTime.parse(map['hora']),
                fotoUrl: map['foto_url'],
              );
            })
            .toList());
  }

  // Subir foto y devolver la URL pública (Uint8List)
  Future<String> subirFoto(Uint8List bytes, String nombreArchivo) async {
    final storageResponse = await _client.storage.from(bucket).uploadBinary(
      nombreArchivo,
      bytes,
      fileOptions: const FileOptions(upsert: true),
    );
    if (storageResponse.isEmpty) {
      throw Exception('No se pudo subir la foto');
    }
    // Obtener URL pública
    final url = _client.storage.from(bucket).getPublicUrl(nombreArchivo);
    return url;
  }

  // Agregar visitante
  Future<void> agregarVisitante({
    required String nombre,
    required String motivo,
    required DateTime hora,
    required Uint8List fotoBytes,
    required String userId,
  }) async {
    final nombreArchivo = '${DateTime.now().millisecondsSinceEpoch}_$userId.jpg';
    final fotoUrl = await subirFoto(fotoBytes, nombreArchivo);
    await _client.from(table).insert({
      'nombre': nombre,
      'motivo': motivo,
      'hora': hora.toIso8601String(),
      'foto_url': fotoUrl,
      'user_id': userId,
    });
  }

  Future<void> deleteVisitante(String id) async {
    await _client.from(table).delete().eq('id', id);
  }
} 