import 'package:english_cart/values/app_colors.dart';
import 'package:english_cart/values/app_styles.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String laber;
  final VoidCallback onTap;

  const AppButton({Key? key, required this.laber, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.black12,
      highlightColor: Colors.black12,
      onTap: () {
        onTap();
      },
      child: Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.black26, offset: Offset(3, 6), blurRadius: 6),
            ],
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          child: Text(
            laber,
            style: AppStyles.h5.copyWith(
              color: AppColors.textColor,
            ),
          )),
    );
  }
}
