import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onItemTapped;

  CustomBottomNavigationBar({
    required this.currentIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onItemTapped,
      selectedItemColor: Colors.black,
      items: const [
        BottomNavigationBarItem(
          icon: ImageIcon(
            AssetImage('assets/icon.png'),
            size: 35,
          ),
          label: "Inicio",
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.confirmation_number_sharp,
            size: 35,
          ),
          label: "Tus Tickets",
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.photo_size_select_actual_rounded,
            size: 35,
          ),
          label: "Premio",
        ),
      ],
    );
  }
}
