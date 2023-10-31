import 'package:flutter/material.dart';

class CustomPageRoute extends PageRouteBuilder {
  CustomPageRoute({required super.pageBuilder})
      : super(
          transitionDuration: const Duration(milliseconds: 400),
          fullscreenDialog: true,
        );

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation, Widget child) =>
      FadeTransition(
        opacity: Tween<double>(begin: 0, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInOut))
            .animate(animation),
        child: child,
      );
}
