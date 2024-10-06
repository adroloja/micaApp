import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mica/controller/auth/Authenticate.dart';
import 'package:mica/controller/signup/SignUpController.dart';
import 'package:mica/dto/NewUserDTO.dart';
import 'package:mica/screens/login_screen.dart';
import 'package:mica/utils/constants.dart';
import 'package:mica/utils/secure_storage.dart';
import 'package:mica/widget/custom_app_bars/custom_back_bar_doc.dart';
import 'package:mica/widget/custom_app_bars/custom_back_bar_signup.dart';
import 'package:mica/widget/labeled_priv_checkbox.dart';
import 'package:mica/widget/labeled_term_checkbox.dart';

class SignupGoogleScreen extends StatefulWidget {
  const SignupGoogleScreen({super.key});

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<SignupGoogleScreen> {
  final _formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final numberController = TextEditingController();
  bool _isAcceptTerms = false;
  bool _isAcceptPriv = false;
  bool _isLoading = false;
  bool _is18yo = false;
  File? _selfieImage;

  @override
  void initState() {
    super.initState();
    firstNameController.text = Credentials.firstName ?? '';
    lastNameController.text = Credentials.lastName ?? '';
    _loadFormData();
  }

  Future<void> _saveFormData() async {
    await SecureStorage.write(
        key: 'sign_firstName', value: firstNameController.text);
    await SecureStorage.write(
        key: 'sign_lastName', value: lastNameController.text);
    await SecureStorage.write(key: 'sign_number', value: numberController.text);
    await SecureStorage.write(
        key: 'sign_isAcceptTerms', value: _isAcceptTerms.toString());
    await SecureStorage.write(
        key: 'sign_isAcceptPriv', value: _isAcceptPriv.toString());

    if (_selfieImage != null) {
      await SecureStorage.write(
          key: 'selfieImageBase64', value: convertImageToBase64(_selfieImage!));
    }
  }

  Future<void> _loadFormData() async {
    firstNameController.text =
        await SecureStorage.read(key: 'sign_firstName') ?? '';
    lastNameController.text =
        await SecureStorage.read(key: 'sign_lastName') ?? '';
    numberController.text = await SecureStorage.read(key: 'sign_number') ?? '';
    _isAcceptTerms =
        (await SecureStorage.read(key: 'sign_isAcceptTerms')) == 'true';
    _isAcceptPriv =
        (await SecureStorage.read(key: 'sign_isAcceptPriv')) == 'true';

    String? base64Image = await SecureStorage.read(key: 'selfieImageBase64');
    if (base64Image != null) {
      setState(() {
        _selfieImage = File.fromRawPath(base64Decode(base64Image));
      });
    }

    setState(() {});
  }

  Future<void> _clearFormData() async {
    await SecureStorage.delete(key: 'sign_firstName');
    await SecureStorage.delete(key: 'sign_lastName');
    await SecureStorage.delete(key: 'sign_number');
    await SecureStorage.delete(key: 'sign_isAcceptTerms');
    await SecureStorage.delete(key: 'sign_isAcceptPriv');
    await SecureStorage.delete(key: 'selfieImageBase64');
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.front,
        imageQuality: 50);

    if (pickedFile != null) {
      setState(() {
        _selfieImage = File(pickedFile.path);
      });
      await SecureStorage.write(
          key: 'selfieImageBase64', value: convertImageToBase64(_selfieImage!));
    } else {
      Fluttertoast.showToast(
        msg: '\n No se tomó ninguna foto \n',
        fontSize: 18,
        toastLength: Toast.LENGTH_LONG,
      );
    }
  }

  String convertImageToBase64(File image) {
    List<int> imageBytes = image.readAsBytesSync();
    return base64Encode(imageBytes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomBackBarSignup(
        route: "",
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 80),
              child: Form(
                key: _formKey, // Asociar la llave global al formulario
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      controller: firstNameController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Introduce un nombre',
                        labelText: 'Nombre',
                        errorMaxLines: 3,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, introduce un nombre';
                        }
                        if (value.length > 25) {
                          return "La longitud máxima para un nombre son 25 caracteres, gracias.";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),
                    TextFormField(
                      controller: lastNameController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Introduce tus apellidos',
                        labelText: 'Apellidos',
                        errorMaxLines: 3,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, introduce tus apellidos';
                        }
                        if (value.length > 25) {
                          return "La longitud máxima para un apellido son 25 caracteres, gracias.";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),
                    TextFormField(
                      controller: numberController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Introduce tu teléfono',
                        labelText: 'Teléfono',
                        errorMaxLines: 3,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, introduce tu teléfono';
                        }
                        final regex = RegExp(r'^[+]?[0-9]+$');
                        if (!regex.hasMatch(value)) {
                          return 'Número de teléfono no válido. Solo se permiten números y el símbolo +.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),
                    Column(
                      children: [
                        GestureDetector(
                          onTap: _pickImage,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.camera_alt_sharp, size: 65),
                              _selfieImage != null
                                  ? const Icon(Icons.check,
                                      color: Colors.green, size: 40)
                                  : Container(),
                            ],
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5.0),
                          child: Text(
                            "Foto obligatoria de la cara del usuario. Esta foto es únicamente con fines de seguridad.",
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: Text(
                            "Si la foto no es correcta no recibirá el premio si gana.",
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red[700]),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        LabeledTermCheckbox(
                          route: "terms_google",
                          value: _isAcceptTerms ? true : false,
                          label: "TÉRMINOS Y CONDICIONES",
                          onChanged: (newValue) {
                            setState(() {
                              _isAcceptTerms = newValue!;
                            });
                          },
                          function: () {
                            _saveFormData();
                            Navigator.pushNamed(context, '/terms_google');
                          },
                        ),
                        LabeledPrivCheckbox(
                          label: "PRIVACIDAD DE DATOS",
                          value: _isAcceptPriv ? true : false,
                          function: () {
                            _saveFormData();
                            Navigator.pushNamed(context, '/priv_google');
                          },
                          onChanged: (newValue) {
                            setState(() {
                              _isAcceptPriv = newValue!;
                            });
                          },
                        ),
                        Row(
                          children: [
                            Checkbox(
                              value: _is18yo,
                              onChanged: (value) {
                                setState(() {
                                  _is18yo = value!;
                                  print(_is18yo);
                                });
                              },
                            ),
                            Expanded(
                                child: Text(
                              "SOY MAYOR DE 18 AÑOS",
                              style: TextStyle(color: Colors.blue),
                            ))
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading
                            ? null
                            : () async {
                                if (_formKey.currentState!.validate()) {
                                  if (_selfieImage == null) {
                                    Fluttertoast.showToast(
                                      msg:
                                          '\n Por favor, para continuar necesitas hacerte un selfie, gracias \n',
                                      fontSize: 18,
                                      toastLength: Toast.LENGTH_LONG,
                                    );
                                    return;
                                  }
                                  if (!_isAcceptPriv || !_isAcceptTerms) {
                                    Fluttertoast.showToast(
                                      msg:
                                          '\n Por favor, debes aceptar los términos y condiciones y la privacidad de datos, gracias \n',
                                      fontSize: 18,
                                      toastLength: Toast.LENGTH_LONG,
                                    );
                                    return;
                                  }
                                  if (!_is18yo) {
                                    Fluttertoast.showToast(
                                      msg:
                                          '\nPara poder registrarte debes ser mayor de edad, gracias \n',
                                      fontSize: 18,
                                      toastLength: Toast.LENGTH_LONG,
                                    );
                                    return;
                                  }

                                  setState(() {
                                    _isLoading = true;
                                  });

                                  NewUserDTO newUser = NewUserDTO(
                                    username:
                                        Credentials.email!.trim().toLowerCase(),
                                    password: "W9z!6Pq#Vt8Lx7",
                                    firstName: firstNameController.value.text,
                                    lastName: lastNameController.value.text,
                                    email:
                                        Credentials.email!.trim().toLowerCase(),
                                    number: numberController.value.text,
                                    verified: Credentials.verified!,
                                  );

                                  Signupcontroller signupController =
                                      Signupcontroller();
                                  try {
                                    Response<dynamic> response =
                                        await signupController.doSignUp(
                                            newUser, _selfieImage!);

                                    Fluttertoast.showToast(
                                      msg: '\n ${response.data} \n',
                                      fontSize: 18,
                                      toastLength: Toast.LENGTH_LONG,
                                    );
                                    Authenticate authenticate = Authenticate();
                                    bool isAuth = await authenticate.auth(
                                        Credentials.email!.trim().toLowerCase(),
                                        "W9z!6Pq#Vt8Lx7");
                                    if (isAuth) {
                                      _clearFormData();
                                      Credentials.isExternal = true;
                                      Navigator.of(context)
                                          .pushReplacementNamed('/main');
                                    } else {
                                      Fluttertoast.showToast(
                                        msg:
                                            '\n Error: No se pudo iniciar sesión \n',
                                        fontSize: 18,
                                        toastLength: Toast.LENGTH_LONG,
                                      );
                                      Navigator.of(context)
                                          .pushReplacementNamed("/");
                                    }
                                  } catch (e) {
                                    Fluttertoast.showToast(
                                      msg: '\n Error: $e \n',
                                      fontSize: 18,
                                      toastLength: Toast.LENGTH_LONG,
                                    );
                                  } finally {
                                    setState(() {
                                      _isLoading = false;
                                    });
                                  }
                                }
                              },
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : const Text('Registrarse'),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
