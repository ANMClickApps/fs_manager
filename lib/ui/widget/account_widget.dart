import 'package:flutter/material.dart';
import 'package:fs_manager/style/brand_color.dart';
import 'package:fs_manager/data/account_logo.dart';

class AccountWidget extends StatelessWidget {
  const AccountWidget({
    Key? key,
    required this.accountLogo,
    required this.userName,
    required this.name,
  }) : super(key: key);

  final AccountLogo accountLogo;
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
                borderRadius: BorderRadius.circular(12.0),
                color: accountLogo.color.withOpacity(0.1),
                border: Border.all(
                  color: accountLogo.color.withOpacity(0.3),
                  width: 1.5,
                ),
              ),
              child: Icon(
                accountLogo.iconData,
                color: accountLogo.color,
                size: 24.0,
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
