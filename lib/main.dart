import 'package:alfi_gest/providers/auth/auth_provider.dart';
import 'package:alfi_gest/screens/auth/auth.dart';
import 'package:alfi_gest/pages/auth/error_page.dart';
import 'package:alfi_gest/screens/profile_screen.dart';
import 'package:alfi_gest/screens/main_screen.dart';
import 'package:alfi_gest/screens/splash.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:alfi_gest/theme.dart';

void main() async {
  // Inizializza il binding ServicesBinding
  WidgetsFlutterBinding.ensureInitialized();

  // Aspetta il completamento dell'inizializzazione di Firebase prima di avviare l'app
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Carica lo stato di 'rememberMe'
  final container = ProviderContainer();
  final authControllerState = container.read(authProvider.notifier);
  await authControllerState.loadRememberMe();
  authControllerState.updateRememberMe(authControllerState.rememberMe);

// Se rememberMe è false, esegui il logout
  if (!authControllerState.rememberMe) {
    await FirebaseAuth.instance.signOut();
  }

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestionale Socie*',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('it', 'IT'), // Italian
        // ... other locales the app supports
      ],
      // Utilizziamo StreamBuilder per osservare lo stato di autenticazione di Firebase e visualizzare la schermata appropriata.
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SplashScreen();
          }

          if (snapshot.hasError) {
            print(snapshot.error);
            return ErrorPage();
          }

          if (snapshot.hasData) {
            return const MainScreen();
          }

          return const AuthScreen();
        },
      ),
      routes: {
        '/mainscreen': (context) => const MainScreen(),
        '/login': (context) => const AuthScreen(),
        '/error-page': (context) => const ErrorPage(),
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}
