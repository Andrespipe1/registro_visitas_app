# Registro de Visitas 🏢

Aplicación Flutter profesional para el registro y control de visitantes en oficinas, usando Supabase como backend.  
Desarrollada por [@Andrespipe1](https://github.com/Andrespipe1)

---

## 📱 Características

- **Login y registro** seguro con correo y contraseña (Supabase Auth)
- **Lista en tiempo real** de visitantes registrados
- **Agregar visitante** con:
  - Nombre
  - Motivo de la visita
  - Fecha y hora (DatePicker)
  - Foto tomada desde la cámara o galería
- **Subida de fotos** a Supabase Storage
- **Eliminación de visitantes** con confirmación
- **UI profesional**: paleta corporativa, iconos, cards, validaciones y mensajes claros
- **Soporte multiplataforma**: Android, Web y (opcionalmente) iOS

---

## 🖼️ Capturas de pantalla


| Login | Lista de visitantes | Nuevo visitante |
|-------|--------------------|-----------------|
| <img width="200" height="400" alt="Login" src="https://github.com/user-attachments/assets/2694095c-4a1b-49aa-a73f-90da231c7a3d" /> | <img width="200" height="400" alt="Lista de visitantes" src="https://github.com/user-attachments/assets/9dd0a193-ea58-4531-9531-dc16b36f1dce" /> | <img width="200" height="400" alt="Nuevo visitante" src="https://github.com/user-attachments/assets/3fd1cdca-7aca-41f6-87ee-da2ef45b5f4a" /> |
---
<img width="900" height="500" alt="imagen" src="https://github.com/user-attachments/assets/0e6f5780-e09c-4a67-b7be-d4e4022e04de" />
<img width="589" height="435" alt="imagen" src="https://github.com/user-attachments/assets/34184d61-2cb0-494c-9b96-bfc50f6f3e1b" />

---
## 🚀 Instalación y ejecución

1. **Clona el repositorio**
   ```sh
   git clone https://github.com/Andrespipe1/registro_visitas_app.git
   cd registro_visitas_app
   ```

2. **Instala las dependencias**
   ```sh
   flutter pub get
   ```

3. **Configura Supabase**
   - Crea un proyecto en [Supabase](https://app.supabase.com/)
   - Crea la tabla `visitantes` y el bucket de storage `fotosvisitantes` (ver abajo)
   - Copia tu URL y anon key en `main.dart`

4. **Permisos Android**
   - Ya configurados en `AndroidManifest.xml` para cámara y almacenamiento

5. **Ejecuta la app**
   ```sh
   flutter run
   ```
   o genera el APK:
   ```sh
   flutter build apk --release
   ```

---

## 🗄️ Estructura de la base de datos (Supabase)

### Tabla: visitantes

```sql
create table public.visitantes (
  id uuid primary key default uuid_generate_v4(),
  nombre text not null,
  motivo text not null,
  hora timestamp with time zone not null default now(),
  foto_url text not null,
  user_id uuid references auth.users(id)
);
```

**Policies (RLS):**
```sql
-- Solo el dueño puede ver, insertar y eliminar
create policy \"Usuarios pueden ver sus visitantes\" on public.visitantes for select using (auth.uid() = user_id);
create policy \"Usuarios pueden insertar sus visitantes\" on public.visitantes for insert with check (auth.uid() = user_id);
create policy \"Usuarios pueden eliminar sus visitantes\" on public.visitantes for delete using (auth.uid() = user_id);
```

### Storage

- Bucket: `fotosvisitantes`
- Permitir acceso autenticado

---

## 📁 Estructura del proyecto

```
lib/
  main.dart
  models/
    visitor.dart
  pages/
    login_page.dart
    register_page.dart
    home_page.dart
    add_visitor_page.dart
    confirm_email_page.dart
  services/
    auth_service.dart
    db_service.dart
  widgets/
    visitor_card.dart
```

---

**¿Quieres que te genere también un PDF con capturas de pantalla o necesitas algún badge extra para el README?**

---

## 🛠️ Principales dependencias

- [supabase_flutter](https://pub.dev/packages/supabase_flutter)
- [image_picker](https://pub.dev/packages/image_picker)
- [intl](https://pub.dev/packages/intl)
- [flutter](https://flutter.dev/)

---

## 👨‍💻 Autor

- **Andrés Tufiño**  
  [GitHub: @Andrespipe1](https://github.com/Andrespipe1)
  - Ecuador

---
