import 'package:flutter/material.dart';

import '../../style/brand_color.dart';
import '../../style/brand_text.dart';

class SettingsItem extends StatelessWidget {
  const SettingsItem({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.iconData,
    required this.ontap,
  }) : super(key: key);
  final String title;
  final String subtitle;
  final IconData iconData;
  final VoidCallback ontap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Row(
        children: [
          Icon(
            iconData,
            size: 32.0,
            color: BrandColor.dark,
          ),
          const SizedBox(width: 12.0),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: BrandText.settingTitle,
              ),
              Text(
                subtitle,
                style: BrandText.settingSubtitle,
              ),
            ],
          )
        ],
      ),
    );
  }
}
