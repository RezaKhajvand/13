import 'package:flutter/material.dart';
import 'package:vpn/constants/constants.dart';
import 'package:vpn/pages/configs_page/configspage.dart';
import 'package:vpn/utils/navigator.dart';

class ConfigCard extends StatelessWidget {
  final String remark;
  final String image;
  const ConfigCard({
    super.key,
    required this.remark,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      splashColor: CustomColors.secendry,
      onTap: () => CustomNav.push(context, const ConfigsPage()),
      child: Container(
        padding: const EdgeInsets.all(16),
        height: 80,
        width: double.infinity,
        decoration: BoxDecoration(
            color: CustomColors.glasscardfill,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(width: .5, color: CustomColors.cardborder)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SizedBox(
                  height: 40,
                  width: 40,
                  child: Image.asset(image),
                ),
                const SizedBox(width: 20),
                Container(
                  width: 1,
                  height: double.infinity,
                  color: CustomColors.buttonhint,
                ),
                const SizedBox(width: 20),
                SizedBox(
                  width: 140,
                  child: Text(
                    remark,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 26,
              width: 26,
              child: CircleAvatar(
                backgroundColor: CustomColors.secendry,
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.black,
                  size: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
