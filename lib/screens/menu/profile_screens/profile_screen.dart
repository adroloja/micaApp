import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mica/controller/recovery_password/recovery_password_controller.dart';
import 'package:mica/controller/update_user/update_user_controller.dart';
import 'package:mica/utils/constants.dart';
import 'package:mica/utils/secure_storage.dart';
import 'package:mica/widget/custom_app_bars/custom_app_bar.dart';
import 'package:mica/widget/custom_app_bars/custom_back_bar.dart';
import 'package:mica/widget/custom_drawer.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  String? typeLogin;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _nameController.text = Credentials.firstName!;
    _lastNameController.text = Credentials.lastName!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomBackBar(
        route: "main",
      ),
      drawer: const CustomDrawer(),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final screenWidth = constraints.maxWidth;
            final screenHeight = constraints.maxHeight;
            // Define anchos específicos según el tamaño de la pantalla
            double paddingHorizontal = constraints.maxWidth > 600 ? 100 : 50;
            double textFieldWidth = constraints.maxWidth > 600 ? 300 : 200;

            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: paddingHorizontal),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          "Email",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "   ${Credentials.email!}",
                          style: TextStyle(fontWeight: FontWeight.w300),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Nombre",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        const SizedBox(height: 5),
                        SizedBox(
                          width: screenWidth * 0.7,
                          child: TextFormField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey.withOpacity(0.3),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        TextButton(
                          child: Text(
                            "Cambiar",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[600],
                                fontSize: 16),
                          ),
                          onPressed: () {
                            Navigator.of(context).pushNamed("/name");
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Apellidos",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        const SizedBox(height: 5),
                        SizedBox(
                          width: screenWidth * 0.7,
                          child: TextFormField(
                            controller: _lastNameController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey.withOpacity(0.3),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        TextButton(
                          child: Text(
                            "Cambiar",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[600],
                                fontSize: 16),
                          ),
                          onPressed: () async {
                            // Navigator.of(context).pushNamed("/last_name");
                            Credentials.lastName =
                                _lastNameController.value.text;
                            UpdateUserController updateUserController =
                                UpdateUserController();
                            await updateUserController.update();
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                    !Credentials.isExternal
                        ? Column(
                            children: [
                              const SizedBox(height: 30),
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Contraseña",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                    TextButton(
                                      child: Text(
                                        "Cambiar",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue[600],
                                            fontSize: 16),
                                      ),
                                      onPressed: () {
                                        RecoveryPasswordController
                                            recoveryPasswordController =
                                            RecoveryPasswordController();
                                        recoveryPasswordController
                                            .recovery(Credentials.email!);
                                        Fluttertoast.showToast(
                                          fontSize: 18,
                                          toastLength: Toast.LENGTH_LONG,
                                          msg:
                                              "\n Se ha enviado un correo de recuperación a ${Credentials.email!}. La primera vez que inicie sesión, deberás introducir su nueva contraseña. \n",
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        : Container(),
                    const SizedBox(height: 30),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Datos de Facturación",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        TextButton(
                          child: Text(
                            "Cambiar",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[600],
                                fontSize: 16),
                          ),
                          onPressed: () {
                            Navigator.of(context).pushNamed('/billing');
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
