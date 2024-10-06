import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mica/controller/recovery_password/recovery_password_controller.dart';
import 'package:mica/utils/constants.dart';
import 'package:mica/utils/secure_storage.dart';

class RecoveryPasswordScreen extends StatefulWidget {
  const RecoveryPasswordScreen({Key? key}) : super(key: key);

  @override
  _RecoveryPasswordScreenState createState() => _RecoveryPasswordScreenState();
}

class _RecoveryPasswordScreenState extends State<RecoveryPasswordScreen> {
  TextEditingController emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 250,
                child: TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Email',
                    labelText: 'Introduce el email',
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                  width: 250,
                  child: ElevatedButton(
                      onPressed: () async {
                        String email = emailController.value.text.trim();
                        print(email);
                        String? password = await SecureStorage.read(key: email);
                        if (password == Credentials.defaultPassword) {
                          Fluttertoast.showToast(
                            fontSize: 18,
                            msg:
                                "\n No se puede cambiar la contraseña de las cuentas con acceso rápido. \n",
                            toastLength: Toast.LENGTH_SHORT,
                          );
                          return;
                        }
                        RecoveryPasswordController recoveryPasswordController =
                            RecoveryPasswordController();
                        try {
                          Response response =
                              await recoveryPasswordController.recovery(email);
                        } catch (err) {
                          print(err);
                        }
                        Fluttertoast.showToast(
                          fontSize: 18,
                          msg:
                              "\n Se ha enviado un correo para recuperar la contraseña \n",
                          toastLength: Toast.LENGTH_LONG,
                        );
                        emailController.text = "";
                        Navigator.of(context).popAndPushNamed("/");
                        setState(() {});
                      },
                      child: const Text("Recuperar"))),
              const SizedBox(
                height: 10,
              ),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed('/');
                  },
                  child: const Text("Volver"))
            ],
          ),
        ),
      ),
    );
  }
}
