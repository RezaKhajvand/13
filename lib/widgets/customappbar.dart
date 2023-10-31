import 'package:flutter/material.dart';
import 'package:vpn/constants/constants.dart';

PreferredSize getCustomAppbar(BuildContext context, IconButton? morebutton,
    {required String title}) {
  return PreferredSize(
    preferredSize: const Size.fromHeight(72),
    child: SizedBox.expand(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: CircleAvatar(
                foregroundColor: Colors.white,
                backgroundColor: CustomColors.circlebutton,
                child: IconButton(
                  splashRadius: 30,
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.close,
                    size: 20,
                  ),
                ),
              ),
            ),
            morebutton == null
                ? const SizedBox()
                : Align(
                    alignment: Alignment.centerRight,
                    child: CircleAvatar(
                      foregroundColor: Colors.white,
                      backgroundColor: CustomColors.circlebutton,
                      child: morebutton,
                    ),
                  ),
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'SpaceGrotesk',
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
