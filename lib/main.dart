import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/home_page.dart';
import 'pages/confirm_email_page.dart';
// Si quieres usar GoogleFonts, descomenta la siguiente línea y agrega google_fonts en pubspec.yaml
// import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://lkpqknghsmhecyiewqgh.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxrcHFrbmdoc21oZWN5aWV3cWdoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTI2MDY5NTYsImV4cCI6MjA2ODE4Mjk1Nn0.XBvyxHKRe2uwtx-s03YIFhHaziUGDRyPtr2Yz35KQ_g',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final Color azul = const Color(0xFF1976D2);
    final Color grisOscuro = const Color(0xFF263238);
    final Color verde = const Color(0xFF43A047);
    final Color fondo = const Color(0xFFF5F5F5);
    final Color error = const Color(0xFFE53935);

    return MaterialApp(
      title: 'Registro Visitas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: azul,
        scaffoldBackgroundColor: fondo,
        appBarTheme: AppBarTheme(
          backgroundColor: azul,
          foregroundColor: Colors.white,
          elevation: 2,
          centerTitle: true,
          titleTextStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
            // fontFamily: 'Montserrat', // Si usas GoogleFonts
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: verde,
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: azul,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: azul.withOpacity(0.2)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: azul.withOpacity(0.2)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: azul, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: error, width: 2),
          ),
          labelStyle: TextStyle(color: grisOscuro),
          prefixIconColor: azul,
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: azul,
          contentTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: azul,
          secondary: verde,
          error: error,
        ),
        // fontFamily: 'Montserrat', // Si usas GoogleFonts
        // textTheme: GoogleFonts.montserratTextTheme(),
      ),
      initialRoute: '/login',
      routes: {
        '/': (context) => const LoginPage(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/home': (context) => const HomePage(),
        '/confirm': (context) => const ConfirmEmailPage(),
      },
    );
  }
}
