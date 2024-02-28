import 'package:alfi_gest/screens/auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SuccessPage extends ConsumerWidget {
  const SuccessPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Brightness brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;

    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(
                top: 100,
                bottom: 20,
                right: 20,
                left: 20,
              ),
              width: 120,
              child: isDarkMode
                  ? Image.asset('assets/images/logo-dark.png')
                  : Image.asset('assets/images/logo-light.png'),
            ),
            const SizedBox(height: 40),
            Text(
              'Operazione Completata!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                color: Theme.of(context).colorScheme.secondary,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 40),
            Center(
              child: Image.asset('assets/images/success.png'),
            ),
            const SizedBox(height: 80),
            ElevatedButton(
              onPressed: () {
                ref.read(isRegisterMemberProvider.notifier).state = false;
                ref.read(isSuccessPageProvider.notifier).state = false;
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.only(left: 40, right: 40),
                minimumSize: Size(0, 48),
                backgroundColor: Theme.of(context).colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                alignment: Alignment.center,
              ),
              child: Text(
                'Login',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(color: Theme.of(context).colorScheme.onPrimary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
