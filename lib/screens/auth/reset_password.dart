import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import 'package:alfi_gest/providers/auth_provider.dart';

class ResetPasswordScreen extends ConsumerWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Brightness brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    final authState = ref.watch(authProvider);
    final authController = ref.read(authProvider.notifier);

    return Scaffold(
      body: GestureDetector(
        onTap: () {
          // Azione da eseguire quando viene premuto ovunque sulla schermata.
          FocusScope.of(context).unfocus(); // Chiudi la tastiera se aperta.
        },
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(
                    top: 20,
                    bottom: 30,
                    right: 20,
                    left: 20,
                  ),
                  width: 130,
                  child: isDarkMode
                      ? Image.asset('assets/images/logo-dark.png')
                      : Image.asset('assets/images/logo-light.png'),
                ),
                const SizedBox(height: 90),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: Form(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          initialValue: authController.state.email,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            fillColor:
                                Theme.of(context).colorScheme.surfaceVariant,
                            filled: true,
                            border: InputBorder.none,
                          ),
                          style: Theme.of(context).textTheme.bodyMedium,
                          keyboardType: TextInputType.emailAddress,
                          autocorrect: false,
                          onChanged: (value) {},
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Per favore inserire un email valida.';
                            }
                            // Regular expression pattern per validare la maggior parte degli indirizzi email.
                            const emailPattern =
                                r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+';
                            // Verifica che il valore inserito corrisponda al pattern dell'email.
                            if (!RegExp(emailPattern).hasMatch(value.trim())) {
                              return 'Per favore inserire un email valida.';
                            }
                            // Se arriva qui, significa che l'email è valida.
                            return null;
                          },
                        ),
                        const SizedBox(height: 13),
                        Row(
                          children: [
                            const Spacer(),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 40, vertical: 14),
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                              ),
                              child: authController == AuthState.authenticating
                                  ? const CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    )
                                  : Text('Reset',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimary
                                                .withOpacity(0.8),
                                          )),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(40, 100, 30, 30),
                  child: GestureDetector(
                    onTap: () {
                      // Azione da eseguire quando si preme l'icona o il testo "Indietro".
                      Navigator.pushNamed(context, '/login');
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.chevron_left, size: 32.0),
                        SizedBox(
                            width:
                                5), // Aggiungi spazio tra l'icona e il testo "Indietro".
                        Text(
                          'Indietro',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
