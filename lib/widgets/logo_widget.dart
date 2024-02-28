import 'package:flutter/widgets.dart';

class LogoWidget extends StatelessWidget {
  final bool isDarkMode;
  final bool isRegisterMember;

  const LogoWidget(
      {Key? key, required this.isDarkMode, required this.isRegisterMember})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          top: isRegisterMember ? 40 : 30, bottom: 50, right: 20, left: 20),
      width: isRegisterMember ? 100 : 130,
      child: Image.asset(isDarkMode
          ? 'assets/images/logo-dark.png'
          : 'assets/images/logo-light.png'),
    );
  }
}
