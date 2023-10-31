import 'package:flutter/material.dart';
import 'package:vpn/constants/constants.dart';

class MenuItem extends StatelessWidget {
  final Icon icon;
  final String title;
  final Function()? ontap;
  const MenuItem(
      {super.key, required this.icon, required this.title, this.ontap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: ontap,
      iconColor: CustomColors.buttonhint,
      textColor: Colors.white,
      leading: icon,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
      title: Text(title),
      titleTextStyle: const TextStyle(fontSize: 14),
      trailing: const Icon(
        Icons.arrow_forward_ios_rounded,
        size: 16,
        color: Colors.white,
      ),
    );
  }
}
