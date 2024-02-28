import 'package:alfi_gest/helpers/result.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

final authProvider = StateNotifierProvider<AuthControllerState, AuthController>(
  (ref) => AuthControllerState(),
);

class AuthController {
  String email;
  String password;
  bool rememberMe;
  bool isLogin;
  bool showPassword;
  AuthState authState = AuthState.initial;

  AuthController({
    this.email = '',
    this.password = '',
    this.rememberMe = false,
    this.isLogin = true,
    this.showPassword = false,
    this.authState = AuthState.initial,
  });

  AuthController copyWith({
    String? email,
    String? password,
    bool? rememberMe,
    bool? isLogin,
    bool? showPassword,
    AuthState? authState,
  }) {
    return AuthController(
      email: email ?? this.email,
      password: password ?? this.password,
      rememberMe: rememberMe ?? this.rememberMe,
      isLogin: isLogin ?? this.isLogin,
      showPassword: showPassword ?? this.showPassword,
      authState: authState ?? this.authState,
    );
  }
}

class AuthControllerState extends StateNotifier<AuthController> {
  AuthControllerState() : super(AuthController());
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void updateEmail(String value) => state = state.copyWith(email: value);
  void updatePassword(String value) => state = state.copyWith(password: value);

  void updateIsLogin(bool value) => state = state.copyWith(isLogin: value);
  void updateShowPassword(bool value) =>
      state = state.copyWith(showPassword: value);
  void updateAuthState(AuthState value) =>
      state = state.copyWith(authState: value);

  Future<void> updateRememberMe(bool value) async {
    state = state.copyWith(rememberMe: value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('rememberMe', value);
    if (value) {
      // Salva email e password solo se "Ricordami" è attivo
      await prefs.setString('email', state.email);
      await prefs.setString('password', state.password);
    } else {
      // Cancella email e password se "Ricordami" non è attivo
      await prefs.remove('email');
      await prefs.remove('password');
    }
  }

  Future<void> loadRememberMe() async {
    final prefs = await SharedPreferences.getInstance();
    bool rememberMeValue = prefs.getBool('rememberMe') ?? false;
    state = state.copyWith(rememberMe: rememberMeValue);
  }

  void logout() async {
    // Resetta lo stato relativo all'utente
    state =
        state.copyWith(email: "", password: "", authState: AuthState.initial);
    // Potresti voler anche aggiornare le preferenze per riflettere questo cambio di stato
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('email');
    await prefs.remove('password');
    await FirebaseAuth.instance.signOut();
  }

  Future<Result<void>> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    updateAuthState(AuthState.authenticating);
    try {
      if (kIsWeb) {
        await _firebaseAuth.setPersistence(state.rememberMe
            ? Persistence.LOCAL
            : Persistence
                .NONE); // Imposta la persistenza in base al valore di rememberMe
      }
      var result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (result.user == null) {
        updateAuthState(AuthState.authenticationFailed);
        return Result<void>(errors: ['An error occurred']);
      }

      updateAuthState(AuthState.authenticated);
      state = state.copyWith(authState: AuthState.authenticated);

      return Result<void>(data: null);
    } on FirebaseAuthException catch (error) {
      updateAuthState(AuthState.authenticationFailed);
      String errorMessage;
      switch (error.code) {
        case 'invalid-email':
          errorMessage = "L'indirizzo email non è valido.";
          break;
        case 'INVALID_LOGIN_CREDENTIALS':
          errorMessage =
              "Le credenziali di accesso fornite non sono valide. Controlla la tua email e password e riprova.";
          break;

        case 'wrong-password':
          errorMessage = "La password inserita è errata.";
          break;
        case 'user-not-found':
          errorMessage = "Nessun utente trovato con questo indirizzo email.";
          break;
        case 'user-disabled':
          errorMessage = "Questo utente è stato disabilitato.";
          break;
        case 'too-many-requests':
          errorMessage =
              "Troppi tentativi di login falliti. Riprova più tardi.";
          break;
        case 'operation-not-allowed':
          errorMessage = "Il login con email e password non è abilitato.";
          break;
        case 'network-request-failed':
          errorMessage =
              "Impossibile connettersi a Internet. Verifica la tua connessione e riprova.";
          break;

        default:
          errorMessage = "Si è verificato un errore imprevisto: ${error.code}";
      }
      return Result<void>(error: errorMessage);
    } on PlatformException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'channel-error':
          errorMessage =
              "Si è verificato un problema di comunicazione. Riprova più tardi.";
          break;
        // Aggiungi qui altri casi di errore specifici della piattaforma
        default:
          errorMessage =
              "Si è verificato un errore imprevisto nella comunicazione con la piattaforma: ${e.code}";
      }
      return Result<void>(error: errorMessage);
    } catch (e) {
      // Gestione di altri tipi di errori non specifici
      return Result<void>(error: "Si è verificato un errore imprevisto.");
    }
  }

  Future<void> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    updateAuthState(AuthState.authenticating);
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      updateAuthState(AuthState.authenticated);
    } on FirebaseAuthException {
      updateAuthState(AuthState.authenticationFailed);
      rethrow;
    }
  }
}

enum AuthState {
  initial,
  authenticating,
  authenticated,
  authenticationFailed,
}
