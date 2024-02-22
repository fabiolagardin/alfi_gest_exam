
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ErrorScreen extends ConsumerWidget {
  const ErrorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Brightness brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    // bool isResetPw = ref.watch(isResetPassword);
    // final authState = ref.watch(authProvider);
    // final authController = ref.read(authProvider.notifier);

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
              'Ops! C’è stato un problema...',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                color: Theme.of(context).colorScheme.secondary,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 40),
            Center(
              child: Image.asset('assets/images/error.png'),
            ),
            const SizedBox(height: 80),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right:20),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/login');
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
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/singin');
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
                      'Riprova',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(color: Theme.of(context).colorScheme.onPrimary),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}