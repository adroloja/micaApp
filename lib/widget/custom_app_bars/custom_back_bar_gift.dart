import 'package:flutter/material.dart';
import 'package:mica/utils/constants.dart';
import 'package:mica/widget/countdown_timer.dart';

class CustomBackBarGift extends StatelessWidget implements PreferredSizeWidget {
  final String route;
  const CustomBackBarGift({super.key, required this.route});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const CountdownTimer(),
      actions: [
        // IconButton(
        //     onPressed: () {},
        //     icon: const Icon(
        //       Icons.card_giftcard_sharp,
        //       size: 35,
        //     ))
      ],
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back,
          size: 30,
        ),
        onPressed: () {
          Navigator.of(context).pushNamed('/$route');
        },
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class CustomNavigationDrawer extends StatelessWidget {
  const CustomNavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: const [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Menú',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
