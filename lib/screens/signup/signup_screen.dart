import 'dart:convert';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mica/controller/signup/SignUpController.dart';
import 'package:mica/dto/NewUserDTO.dart';
import 'package:mica/screens/login_screen.dart';
import 'package:mica/utils/secure_storage.dart';
import 'package:mica/widget/custom_app_bars/custom_back_bar_signup.dart';
import 'package:mica/widget/labeled_priv_checkbox.dart';
import 'package:mica/widget/labeled_term_checkbox.dart';
import 'package:flutter/services.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final password2Controller = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final numberController = TextEditingController();
  bool _isAcceptTerms = false;
  bool _isAcceptPriv = false;
  bool _isPasswordVisible = false;
  bool _isPasswordVisibleInRepeat = false;
  bool _is18yo = false;
  bool _isLoading = false;
  File? _selfieImage;
  CameraController? _cameraController; // Controlador de la cámara
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    _loadFormData();
    _initializeCamera();
  }

  // Inicializa la cámara frontal
  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();

      // Seleccionar la cámara frontal
      final frontCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
      );

      // Crear el controlador de la cámara
      _cameraController = CameraController(
        frontCamera,
        ResolutionPreset.high, // Puedes ajustar la calidad
        enableAudio: false, // Deshabilitar el audio si solo necesitas imagen
      );

      await _cameraController?.initialize();

      setState(() {
        _isCameraInitialized = true;
      });
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Error al inicializar la cámara: $e',
        fontSize: 18,
        toastLength: Toast.LENGTH_LONG,
      );
    }
  }

  // Tomar la foto cuando el usuario presione el botón
  Future<void> _takePicture() async {
    if (!_cameraController!.value.isInitialized) {
      Fluttertoast.showToast(
        msg: 'La cámara no está lista',
        fontSize: 18,
        toastLength: Toast.LENGTH_LONG,
      );
      return;
    }

    try {
      // Tomar la foto
      final XFile picture = await _cameraController!.takePicture();

      // Guardar la foto en el estado
      setState(() {
        _selfieImage = File(picture.path);
      });

      // Guardar la imagen en el almacenamiento seguro
      await SecureStorage.write(
        key: "selfieImageBase64",
        value: convertImageToBase64(_selfieImage!),
      );

      Fluttertoast.showToast(
        msg: 'Foto tomada con éxito',
        fontSize: 18,
        toastLength: Toast.LENGTH_LONG,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Error al tomar la foto: $e',
        fontSize: 18,
        toastLength: Toast.LENGTH_LONG,
      );
    }
  }

  Future<void> _showCameraFlow() async {
    await _initializeCamera();

    if (_isCameraInitialized) {
      // Ocultar la barra de estado y la barra de navegación
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Scaffold(
            body: Stack(
              children: [
                // Vista de la cámara
                _isCameraInitialized
                    ? SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: CameraPreview(_cameraController!),
                      )
                    : const Center(child: CircularProgressIndicator()),

                // Imagen superpuesta de la silueta
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: Opacity(
                      opacity: 0.6, // Controlar la transparencia de la silueta
                      child: Image.asset(
                        'assets/perfil.png', // Imagen de la silueta
                        fit: BoxFit.contain, // Asegura que la imagen se ajuste
                        width: MediaQuery.of(context).size.width *
                            0.8, // Ajustar el tamaño
                      ),
                    ),
                  ),
                ),

                // Botón de cerrar (X) en la parte superior izquierda
                Positioned(
                  top: 40,
                  left: 20,
                  child: IconButton(
                    icon:
                        const Icon(Icons.close, size: 40, color: Colors.white),
                    onPressed: () {
                      // Restaurar las barras del sistema al salir
                      SystemChrome.setEnabledSystemUIMode(
                          SystemUiMode.edgeToEdge);
                      Navigator.pop(context);
                    },
                  ),
                ),

                // Botón de tomar la foto en la parte inferior central
                Positioned(
                  bottom: 50,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: FloatingActionButton(
                      onPressed: () async {
                        await _takePicture();
                        // Restaurar las barras del sistema después de tomar la foto
                        SystemChrome.setEnabledSystemUIMode(
                            SystemUiMode.edgeToEdge);
                        Navigator.pop(context);
                      },
                      child: const Icon(Icons.camera, size: 40),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
  }

  // Future<void> _showCameraFlow() async {
  //   await _initializeCamera();

  //   if (_isCameraInitialized) {
  //     // Ocultar la barra de estado y la barra de navegación
  //     SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

  //     showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return Scaffold(
  //           body: Stack(
  //             children: [
  //               _isCameraInitialized
  //                   ? SizedBox(
  //                       width: MediaQuery.of(context).size.width,
  //                       height: MediaQuery.of(context).size.height,
  //                       child: CameraPreview(_cameraController!),
  //                     )
  //                   : const Center(child: CircularProgressIndicator()),

  //               // Botón de cerrar (X) en la parte superior izquierda
  //               Positioned(
  //                 top: 5,
  //                 left: 20,
  //                 child: IconButton(
  //                   icon:
  //                       const Icon(Icons.close, size: 40, color: Colors.white),
  //                   onPressed: () {
  //                     // Restaurar las barras del sistema al salir
  //                     SystemChrome.setEnabledSystemUIMode(
  //                         SystemUiMode.edgeToEdge);
  //                     Navigator.pop(context);
  //                   },
  //                 ),
  //               ),

  //               // Botón de tomar la foto en la parte inferior central
  //               Positioned(
  //                 bottom: 50,
  //                 left: 0,
  //                 right: 0,
  //                 child: Center(
  //                   child: FloatingActionButton(
  //                     onPressed: () async {
  //                       await _takePicture();
  //                       // Restaurar las barras del sistema después de tomar la foto
  //                       SystemChrome.setEnabledSystemUIMode(
  //                           SystemUiMode.edgeToEdge);
  //                       Navigator.pop(context);
  //                     },
  //                     child: const Icon(Icons.camera, size: 40),
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         );
  //       },
  //     );
  //   }
  // }

  Future<void> _pickImage() async {
    final picker = ImagePicker();

    final pickedFile = await picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.values[0],
        imageQuality: 30);

    if (pickedFile != null) {
      setState(() {
        _selfieImage = File(pickedFile.path);
      });
      await SecureStorage.write(
        key: "selfieImageBase64",
        value: convertImageToBase64(_selfieImage!),
      );
    } else {
      Fluttertoast.showToast(
        msg: '\n No se tomó ninguna foto \n',
        fontSize: 18,
        toastLength: Toast.LENGTH_LONG,
      );
    }

    // final picker = ImagePicker();

    // final pickedFile = await picker.pickImage(
    //     source: ImageSource.camera,
    //     preferredCameraDevice: CameraDevice.values[0],
    //     imageQuality: 30);

    // if (pickedFile != null) {
    //   setState(() {
    //     _selfieImage = File(pickedFile.path);
    //   });
    //   await SecureStorage.write(
    //     key: "selfieImageBase64",
    //     value: convertImageToBase64(_selfieImage!),
    //   );
    // } else {
    //   Fluttertoast.showToast(
    //     msg: '\n No se tomó ninguna foto \n',
    //     fontSize: 18,
    //     toastLength: Toast.LENGTH_LONG,
    //   );
    // }
  }

  Future<void> _saveFormData() async {
    await SecureStorage.write(
      key: 'sign_firstName',
      value: firstNameController.text,
    );
    await SecureStorage.write(
      key: 'sign_lastName',
      value: lastNameController.text,
    );
    await SecureStorage.write(
      key: 'sign_number',
      value: numberController.text,
    );
    await SecureStorage.write(
      key: 'sign_email',
      value: emailController.text,
    );
    await SecureStorage.write(
      key: 'sign_password',
      value: passwordController.text,
    );
    await SecureStorage.write(
      key: 'sign_password2',
      value: password2Controller.text,
    );
    await SecureStorage.write(
      key: 'sign_isAcceptTerms',
      value: _isAcceptTerms.toString(),
    );
    await SecureStorage.write(
      key: 'sign_isAcceptPriv',
      value: _isAcceptPriv.toString(),
    );

    if (_selfieImage != null) {
      await SecureStorage.write(
        key: "selfieImageBase64",
        value: convertImageToBase64(_selfieImage!),
      );
    }
  }

  Future<void> _loadFormData() async {
    firstNameController.text =
        await SecureStorage.read(key: 'sign_firstName') ?? '';
    lastNameController.text =
        await SecureStorage.read(key: 'sign_lastName') ?? '';
    numberController.text = await SecureStorage.read(key: 'sign_number') ?? '';
    emailController.text = await SecureStorage.read(key: 'sign_email') ?? '';
    passwordController.text =
        await SecureStorage.read(key: 'sign_password') ?? '';
    password2Controller.text =
        await SecureStorage.read(key: 'sign_password2') ?? '';
    _isAcceptTerms =
        (await SecureStorage.read(key: 'sign_isAcceptTerms')) == 'true';
    _isAcceptPriv =
        (await SecureStorage.read(key: 'sign_isAcceptPriv')) == 'true';

    // Cargar y convertir la imagen Base64 a File
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
    await SecureStorage.delete(key: 'sign_email');
    await SecureStorage.delete(key: 'sign_password');
    await SecureStorage.delete(key: 'sign_password2');
    await SecureStorage.delete(key: 'sign_isAcceptTerms');
    await SecureStorage.delete(key: 'sign_isAcceptPriv');
    await SecureStorage.delete(key: 'selfieImageBase64');
  }

  String convertImageToBase64(File image) {
    List<int> imageBytes = image.readAsBytesSync();
    return base64Encode(imageBytes);
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
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
                        const SizedBox(
                          height: 30,
                        ),
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
                        const SizedBox(
                          height: 30,
                        ),
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
                        const SizedBox(
                          height: 30,
                        ),
                        TextFormField(
                          controller: emailController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Introduce un correo',
                            labelText: 'Correo',
                            errorMaxLines: 3,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, introduce un correo';
                            }
                            const emailRegex = r'^[^\s@]+@[^\s@]+\.[^\s@]+$';
                            if (!RegExp(emailRegex).hasMatch(value)) {
                              return 'Introduce un correo electrónico válido';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        TextFormField(
                          controller: passwordController,
                          obscureText: !_isPasswordVisible,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            hintText: 'Introduce la contraseña',
                            labelText: 'Contraseña',
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                            ),
                            errorMaxLines: 3,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, introduce una contraseña';
                            }
                            if (value.length < 6 &&
                                !RegExp(r'^(?=.*[A-Z])(?=.*\d)(?=.*[^a-zA-Z\d])[a-zA-Z\d\S]{6,}$')
                                    .hasMatch(value)) {
                              return 'La contraseña debe contener al menos 6 caracteres, una letra mayúscula, un número y un símbolo';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        TextFormField(
                          controller: password2Controller,
                          obscureText: !_isPasswordVisibleInRepeat,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            hintText: 'Vuelve a introducir la contraseña',
                            labelText: 'Repite la contraseña',
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisibleInRepeat =
                                      !_isPasswordVisibleInRepeat;
                                });
                              },
                              icon: Icon(
                                _isPasswordVisibleInRepeat
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                            ),
                            errorMaxLines: 3,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, repite la contraseña';
                            }
                            if (value != passwordController.text) {
                              return 'Las contraseñas no coinciden';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Column(
                          children: [
                            GestureDetector(
                                onTap: _showCameraFlow, // _pickImage,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.camera_alt_sharp,
                                      size: 65,
                                    ),
                                    _selfieImage != null
                                        ? const Icon(
                                            Icons.check,
                                            color: Colors.green,
                                            size: 40,
                                          )
                                        : Container(),
                                  ],
                                )),
                            SizedBox(
                              height: 6,
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5.0),
                              child: Text(
                                "Foto obligatoria de la cara del usuario. Por fines de seguridad.",
                                maxLines: 2,
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              child: Text(
                                "Si la foto no es correcta no recibirá el premio si gana.",
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red[700]),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            LabeledTermCheckbox(
                              route: "terms_signup",
                              label: "TÉRMINOS Y CONDICIONES",
                              value: _isAcceptTerms ? true : false,
                              function: () {
                                _saveFormData();
                                Navigator.pushNamed(context, '/terms_signup');
                              },
                              onChanged: (newValue) {
                                setState(() {
                                  _isAcceptTerms = newValue!;
                                });
                              },
                            ),
                            LabeledPrivCheckbox(
                              label: "PRIVACIDAD DE DATOS",
                              value: _isAcceptPriv ? true : false,
                              function: () {
                                _saveFormData();
                                Navigator.pushNamed(context, '/priv');
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
                                const Expanded(
                                    child: Text(
                                  "SOY MAYOR DE 18 AÑOS",
                                  style: TextStyle(color: Colors.blue),
                                ))
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
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
                                              '\n Para poder registrarte debes ser mayor de edad, gracias \n',
                                          fontSize: 18,
                                          toastLength: Toast.LENGTH_LONG,
                                        );
                                        return;
                                      }

                                      setState(() {
                                        _isLoading = true;
                                      });

                                      NewUserDTO newUser = NewUserDTO(
                                        username: emailController.value.text
                                            .trim()
                                            .toLowerCase(),
                                        password: passwordController.value.text,
                                        firstName:
                                            firstNameController.value.text,
                                        lastName: lastNameController.value.text,
                                        email: emailController.value.text
                                            .trim()
                                            .toLowerCase(),
                                        number: numberController.value.text,
                                        verified: false,
                                      );

                                      Signupcontroller signupController =
                                          Signupcontroller();
                                      try {
                                        // Convertir XFile a File
                                        File selfieFile = _selfieImage!;

                                        // Llamar a doSignUp con el archivo
                                        Response<dynamic> response =
                                            await signupController.doSignUp(
                                          newUser,
                                          selfieFile,
                                        );

                                        Fluttertoast.showToast(
                                          msg:
                                              "\n ¡Registro exitoso! Por favor, revisa tu correo electrónico para validar tu cuenta. \n",
                                          fontSize: 18,
                                          toastLength: Toast.LENGTH_LONG,
                                        );
                                        _clearFormData();
                                        Navigator.of(context)
                                            .pushReplacementNamed('/');
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
                        const SizedBox(
                          height: 40,
                        ),
                      ]),
                ),
              ),
            ),
          ),
        ));
  }
}
