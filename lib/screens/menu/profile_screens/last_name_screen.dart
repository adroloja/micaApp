import 'package:flutter/material.dart';
import 'package:mica/controller/update_user/update_user_controller.dart';
import 'package:mica/utils/constants.dart';
import 'package:mica/widget/custom_app_bars/custom_back_bar.dart';

class LastNameScreen extends StatefulWidget {
  const LastNameScreen({Key? key}) : super(key: key);

  @override
  _LastNameScreenState createState() => _LastNameScreenState();
}

class _LastNameScreenState extends State<LastNameScreen> {
  final TextEditingController lastNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'El apellido no puede estar vacío';
    } else if (RegExp(r'\d').hasMatch(value)) {
      return 'El apellido no puede contener números';
    }
    return null;
  }

  Widget _buildNameInputField({
    required TextEditingController controller,
    required String labelText,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(
            color: Colors.blueAccent,
            width: 2.0,
          ),
        ),
        errorMaxLines: 3,
        errorStyle: const TextStyle(color: Colors.red, fontSize: 12),
      ),
      validator: validator,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomBackBar(
        route: "profile",
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(30.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 50),
                _buildNameInputField(
                  controller: lastNameController,
                  labelText: "Nuevo apellido",
                  validator: _validateName,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState?.validate() == true) {
                      Credentials.lastName = lastNameController.value.text;
                      UpdateUserController updateUserController =
                          UpdateUserController();
                      await updateUserController.update();
                      Navigator.of(context).pushReplacementNamed("/profile");
                    }
                  },
                  child: const Text('Guardar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
