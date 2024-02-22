import 'package:alfi_gest/providers/auth_provider.dart';
import 'package:alfi_gest/screens/auth/auth.dart';
import 'package:alfi_gest/screens/auth/error_screen.dart';
import 'package:alfi_gest/screens/auth/reset_password.dart';
import 'package:alfi_gest/screens/clubs_screen.dart';
import 'package:alfi_gest/screens/main_screen.dart';
import 'package:alfi_gest/screens/members/form_member.dart';
import 'package:alfi_gest/screens/members/members_screen.dart';
import 'package:alfi_gest/screens/auth/success_screen.dart';
import 'package:alfi_gest/screens/splash.dart';
import 'package:alfi_gest/screens/profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
  final authControllerState = AuthControllerState();
  await authControllerState.loadRememberMe();
  AuthControllerState().updateRememberMe(authControllerState.state.rememberMe);
// Se rememberMe è false, esegui il logout
  if (!authControllerState.state.rememberMe) {
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
      // Utilizziamo StreamBuilder per osservare lo stato di autenticazione di Firebase e visualizzare la schermata appropriata.
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SplashScreen();
          }

          if (snapshot.hasError) {
            // Gestisci l'errore qui
            print(snapshot.error);
            return ErrorScreen(); // sostituisci con la tua schermata di errore
          }

          if (snapshot.hasData) {
            return const MainScreen();
          }

          return const AuthScreen();
        },
      ),
      routes: {
        '/mainscreen': (context) => const MainScreen(),
        '/socie': (context) => const MembersScreen(),
        '/circoli': (context) => const ClubsScreen(),
        '/singin': (context) => const CreateMemberForm(),
        '/login': (context) => const AuthScreen(),
        '/reset-password': (context) => const ResetPasswordScreen(),
        '/success-page': (context) => const SuccessScreen(),
        '/error-page': (context) => const ErrorScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}
