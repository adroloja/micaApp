import 'package:flutter/material.dart';
import 'package:mica/utils/secure_storage.dart';

class CreditCardWidget extends StatelessWidget {
  final String cardNumber;
  final String cardHolder;
  final String expiryDate;

  const CreditCardWidget({
    Key? key,
    required this.cardNumber,
    required this.cardHolder,
    required this.expiryDate,
  }) : super(key: key);

  Future<void> deleteSecureStorage() async {
    await SecureStorage.delete(key: "card_number");
    await SecureStorage.delete(key: "card_holder");
    await SecureStorage.delete(key: "expiryDate");
  }

  Future<void> _showConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // El usuario debe seleccionar una opción
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmación'),
          content: const Text(
              '¿Estás seguro de que deseas eliminar esta información?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
              },
            ),
            TextButton(
              child: const Text('Eliminar'),
              onPressed: () async {
                await deleteSecureStorage(); // Elimina la información
                Navigator.of(context).pop(); // Cierra el diálogo
                Navigator.of(context).pushReplacementNamed(
                    "/billing"); // Navega a la otra página
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      elevation: 5,
      color: Colors.blueAccent,
      child: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '**** **** **** ${cardNumber.isNotEmpty && cardNumber.length >= 4 ? cardNumber.substring(cardNumber.length - 4) : "0000"}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete_rounded,
                      color: Colors.red[600], size: 30),
                  onPressed: () {
                    _showConfirmationDialog(
                        context); // Muestra el diálogo de confirmación
                  },
                )
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Nombre del Titular',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
            Text(
              cardHolder,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text(
                  'Fecha de Vencimiento',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                Text(
                  expiryDate,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
