import 'package:flutter/material.dart';
import 'package:mica/utils/constants.dart';
import 'package:mica/widget/countdown_timer.dart';

class CustomBackBarDoc extends StatelessWidget implements PreferredSizeWidget {
  final String route;
  final String text;

  const CustomBackBarDoc({super.key, required this.route, required this.text});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.of(context).pushReplacementNamed('/$route');
        },
      ),
      title: Center(
        child: Text(
          text,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w400,
              ),
        ),
      ),
      actions: [
        SizedBox(
          width: 35,
        )
      ],
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
