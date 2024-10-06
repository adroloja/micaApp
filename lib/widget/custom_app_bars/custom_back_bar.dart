import 'package:flutter/material.dart';
import 'package:mica/utils/constants.dart';
import 'package:mica/widget/countdown_timer.dart';

class CustomBackBar extends StatelessWidget implements PreferredSizeWidget {
  final String route;
  const CustomBackBar({super.key, required this.route});

  @override
  Widget build(BuildContext context) {
    return AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushNamed('/$route');
          },
        ),
        title: CountdownTimer());
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
