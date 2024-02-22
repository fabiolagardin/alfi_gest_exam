import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import 'package:alfi_gest/providers/auth_provider.dart';
import 'package:alfi_gest/widgets/login.dart';

class AuthScreen extends ConsumerWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final authController = ref.read(authProvider.notifier);
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus(); // Chiudi la tastiera se aperta.
        },
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 110, horizontal: 55),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LogoWidget(isDarkMode: isDarkMode),
                  authState.authState == AuthState.authenticating
                      ? const CircularProgressIndicator()
                      : LoginWidget(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LogoWidget extends StatelessWidget {
  final bool isDarkMode;

  const LogoWidget({Key? key, required this.isDarkMode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 30, bottom: 50, right: 20, left: 20),
      width: 130,
      child: Image.asset(isDarkMode
          ? 'assets/images/logo-dark.png'
          : 'assets/images/logo-light.png'),
    );
  }
}
