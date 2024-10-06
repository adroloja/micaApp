import 'package:flutter/material.dart';

class CustomFootNavigationBar extends StatelessWidget {
  const CustomFootNavigationBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 40),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: InkWell(
              onTap: () {
                Navigator.of(context).pushReplacementNamed('/own_numbers');
              },
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.confirmation_number_sharp,
                    size: 35,
                  ),
                  SizedBox(height: 4),
                  Text("Tus números"),
                ],
              ),
            ),
          ),
          const Expanded(
            flex: 4,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.play_arrow,
                  size: 35,
                ),
                SizedBox(height: 4),
                Text("Inicio"),
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: InkWell(
              onTap: () {
                Navigator.of(context).pushNamed('/house_details');
              },
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.photo_size_select_actual_rounded,
                    size: 35,
                  ),
                  SizedBox(height: 4),
                  Text("Fotos"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
