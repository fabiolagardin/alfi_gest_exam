import 'package:alfi_gest/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginWidget extends ConsumerStatefulWidget {
  const LoginWidget({super.key});
  @override
  LoginWidgetState createState() => LoginWidgetState();
}

class LoginWidgetState extends ConsumerState<LoginWidget> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final authController = ref.watch(authProvider
        .notifier); // Ottieni il riferimento al controller di autenticazione
    final authControllerState = ref.read(authProvider.notifier).state;
    ValueNotifier<bool> rememberMe =
        ValueNotifier<bool>(authControllerState.rememberMe);
    emailController.text = authControllerState.email;
    passwordController.text = authControllerState.password;

    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: emailController,
            onChanged: (value) =>
                ref.read(authProvider.notifier).updateEmail(value),
            decoration: InputDecoration(
              labelText: 'Email *',
              fillColor: Theme.of(context).colorScheme.surfaceVariant,
              filled: true,
              border: InputBorder.none,
            ),
            style: Theme.of(context).textTheme.bodyMedium,
            keyboardType: TextInputType.emailAddress,
            autocorrect: false,
            textCapitalization: TextCapitalization.none,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Per favore inserire un email valida.';
              }

              // Regular expression pattern per validare la maggior parte degli indirizzi email.
              const emailPattern = r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+';

              // Verifica che il valore inserito corrisponda al pattern dell'email.
              if (!RegExp(emailPattern).hasMatch(value.trim())) {
                return 'Per favore inserire un email valida.';
              }

              // Se arriva qui, significa che l'email è valida.
              return null;
            },
          ),
          const SizedBox(height: 30),

          TextFormField(
            // initialValue: authControllerState.password,
            controller: passwordController,
            onChanged: (value) =>
                ref.read(authProvider.notifier).updatePassword(value),
            decoration: InputDecoration(
              labelText: 'Password *',
              suffixIcon: InkWell(
                onTap: () {
                  authController
                      .updateShowPassword(!authControllerState.showPassword);
                  ref
                      .read(authProvider.notifier)
                      .updateEmail(emailController.text);
                  ref
                      .read(authProvider.notifier)
                      .updatePassword(passwordController.text);
                },
                child: Icon(authControllerState.showPassword
                    ? Icons.visibility
                    : Icons.visibility_off),
              ),
              fillColor: Theme.of(context).colorScheme.surfaceVariant,
              filled: true,
              border: InputBorder.none,
            ),
            style: Theme.of(context).textTheme.bodyMedium,
            obscureText: !authControllerState.showPassword,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Per favore, inserisci una password!';
              }
              
              //if (value == null || value.trim().length < 5) {
                //return 'La password deve avere almeno 8 caratteri.';
              //}

              //if (!value.contains(RegExp(r'[0-9]'))) {
                //return 'La password deve contenere almeno un numero';
              //}

              //if (!value.contains(RegExp(r'[A-Z]'))) {
                //return 'La password deve contenere almeno una lettera maiuscola';
              //}

              return null;
            },
          ),
          const SizedBox(height: 12), // Aggiunge una riga
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ValueListenableBuilder<bool>(
                valueListenable: rememberMe,
                builder: (context, value, child) {
                  return Row(
                    children: [
                      Transform.translate(
                        offset: const Offset(-14.0, 0),
                        child: Checkbox(
                          value: value,
                          checkColor: Theme.of(context).colorScheme.onPrimary,
                          fillColor: MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.selected)) {
                                return Theme.of(context).colorScheme.primary;
                              }
                              return Theme.of(context)
                                  .colorScheme
                                  .onInverseSurface;
                            },
                          ),
                          onChanged: (newValue) {
                            ref
                                .read(authProvider.notifier)
                                .updateEmail(emailController.text);
                            ref
                                .read(authProvider.notifier)
                                .updatePassword(passwordController.text);
                            authControllerState.rememberMe = newValue!;
                            authController.updateRememberMe(newValue);
                          },
                        ),
                      ),
                      Transform.translate(
                        offset: const Offset(-18.0, 0),
                        child: Text(
                          'Ricordami',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      ),
                    ],
                  );
                },
              ),
              const Spacer(), // Spinge il testo "Password dimenticata?" a destra
              TextButton(
                onPressed: () =>
                    Navigator.pushNamed(context, '/reset-password'),
                child: Text(
                  'Password dimenticata?',
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontSize:
                          Theme.of(context).textTheme.labelMedium!.fontSize,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      decorationColor:
                          Theme.of(context).colorScheme.onSurfaceVariant,
                      height: 1.5),
                ),
              ),
            ],
          ),
          Row(
            children: [
              const Spacer(
                flex: 6,
              ),
              ElevatedButton(
                onPressed: () async {
                  ref
                      .read(authProvider.notifier)
                      .updateEmail(emailController.text);
                  ref
                      .read(authProvider.notifier)
                      .updatePassword(passwordController.text);
                  final email = authController.state.email;
                  final password = authController.state.password;
                  final formState = formKey.currentState;
                  final formValid = formKey.currentState!.validate();
                  if (!formValid) {
                    setState(() {
                      // Questo forzerà il rebuild dei widget e mostrerà i messaggi di errore
                    });
                  }
                  if (formState != null && formState.validate()) {
                    formState.save();
                    final scaffoldMessenger = ScaffoldMessenger.of(context);
                    final result = await authController
                        .signInWithEmailAndPassword(email, password);
                    // Gestisci l'errore
                    if (result.error != null) {
                      scaffoldMessenger.showSnackBar(
                        SnackBar(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            content: Text(
                              'Errore durante l\'autenticazione ${result.error}',
                              style: TextStyle(
                                color: Colors
                                    .white, // Cambia il colore del testo qui
                              ),
                            ),
                            backgroundColor: Color(0xFF8C1D18),
                            behavior: SnackBarBehavior.floating),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                child: authController == AuthState.authenticating
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : Text('Login',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimary
                                  .withOpacity(0.8),
                            )),
              ),
            ],
          ),
          const SizedBox(height: 55),
          Text(
            'Non hai la tessera?',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/singin');
            },
            style: TextButton.styleFrom(
              minimumSize: Size.zero,
              padding: EdgeInsets.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'Tesserati online con noi!',
              style: TextStyle(
                  decoration:
                      TextDecoration.underline, // Aggiunge la sottolineatura
                  fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  decorationColor:
                      Theme.of(context).colorScheme.onSurfaceVariant,
                  height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}
