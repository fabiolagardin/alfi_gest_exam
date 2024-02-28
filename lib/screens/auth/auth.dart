import 'package:alfi_gest/pages/auth/error_page.dart';
import 'package:alfi_gest/pages/auth/reset_password.dart';
import 'package:alfi_gest/pages/auth/success_page.dart';
import 'package:alfi_gest/pages/auth/register_member.dart';
import 'package:alfi_gest/widgets/logo_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import 'package:alfi_gest/providers/auth/auth_provider.dart';
import 'package:alfi_gest/pages/auth/login.dart';

final isRegisterMemberProvider = StateProvider<bool>((ref) => false);
final isErrorPageProvider = StateProvider<bool>((ref) => false);
final isSuccessPageProvider = StateProvider<bool>((ref) => false);
final isResetPasswordPage = StateProvider<bool>((ref) => false);

class AuthScreen extends ConsumerWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print("isResetPasswordPage: ${ref.watch(isResetPasswordPage)}");
    final authState = ref.watch(authProvider);
    final isRegisterMember = ref.watch(isRegisterMemberProvider);
    final isErrorPage = ref.watch(isErrorPageProvider);
    final isSuccessPage = ref.watch(isSuccessPageProvider);
    final isResetPassword = ref.watch(isResetPasswordPage);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return isErrorPage || isSuccessPage
        ? isErrorPage
            ? ErrorPage()
            : SuccessPage()
        : isResetPassword
            ? ResetPasswordPage()
            : Scaffold(
                body: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                  },
                  child: Center(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: isRegisterMember ? 15 : 110,
                            horizontal: isRegisterMember ? 34 : 55),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            LogoWidget(
                                isDarkMode: isDarkMode,
                                isRegisterMember: isRegisterMember),
                            authState.authState == AuthState.authenticating
                                ? const CircularProgressIndicator()
                                : !isRegisterMember
                                    ? LoginPage()
                                    : RegisterMemberForm(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
  }
}
