import 'package:flutter/material.dart';
import 'package:mica/utils/secure_storage.dart';

class EditCreditCardWidget extends StatefulWidget {
  final String initialCardNumber;
  final String initialCardHolder;
  final String initialExpiryDate;

  const EditCreditCardWidget({
    Key? key,
    required this.initialCardNumber,
    required this.initialCardHolder,
    required this.initialExpiryDate,
  }) : super(key: key);

  @override
  _EditCreditCardWidgetState createState() => _EditCreditCardWidgetState();
}

class _EditCreditCardWidgetState extends State<EditCreditCardWidget> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _cardNumberController;
  late TextEditingController _cardHolderController;
  late TextEditingController _expiryDateController;

  @override
  void initState() {
    super.initState();
    _cardNumberController =
        TextEditingController(text: widget.initialCardNumber);
    _cardHolderController =
        TextEditingController(text: widget.initialCardHolder);
    _expiryDateController =
        TextEditingController(text: widget.initialExpiryDate);
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _cardHolderController.dispose();
    _expiryDateController.dispose();
    super.dispose();
  }

  void saveCardInfo() {
    SecureStorage.write(key: "card_number", value: _cardNumberController.text);
    SecureStorage.write(key: "card_holder", value: _cardHolderController.text);
    SecureStorage.write(key: "expiryDate", value: _expiryDateController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              controller: _cardNumberController,
              decoration: const InputDecoration(labelText: 'Número de Tarjeta'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty || value.length != 16) {
                  return 'Por favor ingrese un número de tarjeta válido';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _cardHolderController,
              decoration:
                  const InputDecoration(labelText: 'Nombre del Titular'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese el nombre del titular';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _expiryDateController,
              decoration: const InputDecoration(
                  labelText: 'Fecha de Vencimiento (MM/AA)'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null ||
                    value.isEmpty ||
                    !RegExp(r'^\d{2}/\d{2}$').hasMatch(value)) {
                  return 'Por favor, introduce una fecha de vencimiento válida (MM/AA)';
                }

                final parts = value.split('/');
                if (parts.length != 2) {
                  return 'Formato de fecha inválido';
                }

                final month = int.tryParse(parts[0]);
                final year = int.tryParse(parts[1]);
                if (month == null || year == null || month < 1 || month > 12) {
                  return 'Mes o año inválido';
                }

                final now = DateTime.now();
                final currentYear = now.year;
                final currentMonth = now.month;

                final expiryDate = DateTime(year + 2000, month);

                if (expiryDate.year == currentYear &&
                    expiryDate.month < currentMonth) {
                  return 'La fecha de vencimiento debe ser mayor que la fecha actual';
                }

                return null;
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  saveCardInfo();
                  // Puedes descomentar esta línea si deseas eliminar los datos de almacenamiento seguro
                  // setState(() { deleteSecureStorage(); });
                  Navigator.of(context).pushReplacementNamed("/billing");
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }
}
