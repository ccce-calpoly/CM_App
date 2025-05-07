import 'package:ccce_application/common/theme/colors.dart';
import 'package:flutter/material.dart';

class GoldAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final TextStyle? titleTextStyle;
  final Widget? leading;
  final List<Widget>? actions;
  final double height;

  const GoldAppBar({
    Key? key,
    this.title,
    this.titleTextStyle,
    this.leading,
    this.actions,
    this.height = kToolbarHeight,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(height * 0.6);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: true,
      title: title != null ? Text(title!, style: titleTextStyle) : null,
      leading: leading,
      actions: actions,
      flexibleSpace: ShaderMask(
        shaderCallback: (Rect bounds) {
          return const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFD8B45B), // Left color
              AppColors.darkGold, // Start of right gradient
              Color(0xFFD8B45B), // End of right gradient (matches left)
            ],
            stops: [
              0.5, // Left side ends at 50%
              0.5, // Right side gradient starts at 50%
              1.0, // Right side gradient ends at 100%
            ],
          ).createShader(bounds);
        },
        child: Container(
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.transparent,
      elevation: 2,
    );
  }
}
