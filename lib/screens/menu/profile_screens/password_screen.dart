import 'package:flutter/material.dart';
import 'package:mica/controller/update_password/update_password_controller.dart';
import 'package:mica/utils/constants.dart';
import 'package:mica/widget/custom_app_bars/custom_back_bar.dart';
import 'package:mica/utils/secure_storage.dart';

class PasswordScreen extends StatefulWidget {
  const PasswordScreen({Key? key}) : super(key: key);

  @override
  _PasswordScreenState createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  String? passwordStored;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    getPasswordFromSecuredStorage();
    checkPassword();
    super.initState();
  }

  getPasswordFromSecuredStorage() async {
    passwordStored = await SecureStorage.read(key: Credentials.email!);
  }

  Future<void> checkPassword() async {
    String? password = await SecureStorage.read(key: Credentials.email!);
    String? defaultPassword = await SecureStorage.read(key: "defaultPassword");
    if (password != null && password == defaultPassword) {
      _currentPasswordController.text = password;
    }
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingrese una contraseña';
    }
    if (!RegExp(r'^(?=.*[A-Z])(?=.*\d)(?=.*[^a-zA-Z\d])[a-zA-Z\d\S]{6,}$')
        .hasMatch(value)) {
      return 'La contraseña debe contener al menos 6 caracteres, una letra mayúscula, un número y un símbolo';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomBackBar(route: "profile"),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 50),
                _buildPasswordInputField(
                  controller: _currentPasswordController,
                  labelText: 'Contraseña Actual',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese su contraseña actual';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                _buildPasswordInputField(
                  controller: _newPasswordController,
                  labelText: 'Nueva Contraseña',
                  validator: _validatePassword,
                ),
                const SizedBox(height: 20),
                _buildPasswordInputField(
                  controller: _confirmPasswordController,
                  labelText: 'Confirmar Nueva Contraseña',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor confirme su nueva contraseña';
                    }
                    if (value != _newPasswordController.text) {
                      return 'Las contraseñas no coinciden';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_currentPasswordController.value.text ==
                          passwordStored) {
                        UpdatePasswordController updatePasswordController =
                            UpdatePasswordController();
                        updatePasswordController.updatePassword(
                            _newPasswordController.value.text, context);
                      }
                    },
                    child: const Text(
                      'Guardar Cambios',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordInputField({
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
      obscureText: true,
      validator: validator,
    );
  }
}
