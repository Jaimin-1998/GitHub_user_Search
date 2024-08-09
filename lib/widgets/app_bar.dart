import 'package:flutter/material.dart';
import 'package:githubsearchtesk/utils/app_colors.dart';

AppBar appBar(BuildContext context, String str, bool leading ,{List<Widget>? actions}) {
  return AppBar(
    backgroundColor: AppColors.clrAppBar,
    surfaceTintColor: AppColors.clrAppBar,
    title: str.isEmpty
        ? Container()
        : Text(str,
            style: const TextStyle(color: AppColors.clrWhite, fontSize: 20)),
    leadingWidth: 10,
    leading:leading? InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: const Icon(Icons.arrow_back_ios, color: AppColors.clrWhite)):const SizedBox(),
    actions: actions ?? [],
  );
}
