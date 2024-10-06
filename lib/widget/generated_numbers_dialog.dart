import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mica/utils/constants.dart';

class GeneratedNumbersDialog extends StatelessWidget {
  final List<dynamic> generatedNumbers;
  final bool isGift;

  const GeneratedNumbersDialog(
      {super.key, required this.generatedNumbers, required this.isGift});

  @override
  Widget build(BuildContext context) {
    // Obtener la fecha actual con el formato requerido
    String currentDate = DateFormat('dd / MM / yyyy').format(DateTime.now());

    return AlertDialog(
      title: const Text(
        "Ticket/s",
        textAlign: TextAlign.center,
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: generatedNumbers.map((number) {
            return Container(
              width: double.infinity,
              height: 110,
              margin: const EdgeInsets.only(top: 10),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image(
                      image: AssetImage(isGift
                          ? 'assets/ticket_regalo.png'
                          : 'assets/ticket.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                  Center(
                    child: Text(
                      number.toString().padLeft(7, '0'),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 50,
                        fontFamily: 'HelveticaCompressed',
                        color: isGift
                            ? const Color.fromRGBO(101, 82, 137, 1.0)
                            : const Color.fromRGBO(47, 87, 112, 1.0),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 6,
                    left: 5,
                    right: 5,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isGift ? Credentials.giftEmail! : Credentials.email!,
                          style: TextStyle(
                            fontFamily: 'HelveticaCompressed',
                            fontSize: 9,
                            color: isGift
                                ? const Color.fromRGBO(101, 82, 137, 1.0)
                                : const Color.fromRGBO(47, 87, 112, 1.0),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 1),
                          child: Text(
                            "Fecha Compra: $currentDate",
                            style: TextStyle(
                              fontFamily: 'HelveticaCompressed',
                              fontSize: 9,
                              color: isGift
                                  ? const Color.fromRGBO(101, 82, 137, 1.0)
                                  : const Color.fromRGBO(47, 87, 112, 1.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
      actions: [
        TextButton(
          child: const Text("Cerrar"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
