import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fs_manager/style/brand_color.dart';

class AccountWidget extends StatelessWidget {
  const AccountWidget({
    Key? key,
    required this.iconPath,
    required this.userName,
    required this.name,
  }) : super(key: key);

  final String iconPath;
  final String userName;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              height: 48.0,
              width: 48.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    12.0,
                  ),
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                        offset: Offset(0, 4),
                        blurRadius: 4.0,
                        spreadRadius: 0,
                        color: Colors.black26)
                  ]),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset(iconPath),
              ),
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 240.0,
                        child: Text(
                          userName,
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: BrandColor.dark.withOpacity(0.5),
                    size: 16.0,
                  )
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8.0)
      ],
    );
  }
}
