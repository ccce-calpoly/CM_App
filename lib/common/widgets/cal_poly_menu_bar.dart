import 'package:flutter/material.dart';

class CalPolyMenuBar extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const CalPolyMenuBar({super.key, required this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Image.asset('assets/icons/cal_poly_white.png'),
      ),
      IconButton(
        icon: const Icon(
          Icons.menu,
          color: Colors.white,
        ),
        onPressed: () {
          scaffoldKey.currentState?.openEndDrawer();
        },
      ),
    ]);
  }
}
